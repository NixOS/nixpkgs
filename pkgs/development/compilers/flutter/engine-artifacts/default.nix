{ lib
, stdenv
, hostPlatform
, engineVersion
, fetchurl
, fetchzip
, autoPatchelfHook
, gtk3
, flutterVersion
, unzip
, stdenvNoCC
}:

let
  hashes = (import ./hashes.nix).${engineVersion} or
    (throw "There are no known artifact hashes for Flutter engine version ${engineVersion}.");
  noticeText = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "flutter-notice";
    version = engineVersion;
    dontUnpack = true;
    src = fetchurl {
      pname = "flutter-sky_engine-LICENSE";
      version = engineVersion;
      url = "https://raw.githubusercontent.com/flutter/engine/${engineVersion}/sky/packages/sky_engine/LICENSE";
      sha256 = hashes.skyNotice;
    };
    flutterNotice = fetchurl {
      pname = "flutter-LICENSE";
      version = engineVersion;
      url = "https://raw.githubusercontent.com/flutter/flutter/${flutterVersion}/LICENSE";
      sha256 = hashes.flutterNotice;
    };
    installPhase =
      ''
        SRC_TEXT="$(cat $src)"
        FLUTTER_NOTICE_TEXT="$(cat $flutterNotice)"
        cat << EOF > $out
        This artifact is from the Flutter SDK's engine.
        This file carries third-party notices for its dependencies.
        See also other files, that have LICENSE in the name, in the artifact directory.

        Appendix 1/2: merged sky_engine LICENSE file (also found at ${finalAttrs.src.url})
        $SRC_TEXT

        Appendix 2/2: Flutter license (also found at ${finalAttrs.flutterNotice.url})
        $FLUTTER_NOTICE_TEXT
        EOF
      '';
  });
  artifacts =
    {
      common = {
        flutter_patched_sdk = { archive = "flutter_patched_sdk.zip"; };
        flutter_patched_sdk_product = { archive = "flutter_patched_sdk_product.zip"; };
      };
      platform = {
        android =
          (lib.genAttrs
            [ "arm" "arm64" "x64" ]
            (arch:
              {
                base = [
                  { archive = "artifacts.zip"; }
                ];
                variants = lib.genAttrs [ "profile" "release" ]
                  (variant: [
                    { archive = "artifacts.zip"; }
                    { subdirectory = true; archive = "${lib.toLower hostPlatform.uname.system}-x64.zip"; }
                  ]);
              })) //
          {
            "x86" = {
              base = [
                { archive = "artifacts.zip"; }
              ];
              variants.jit-release = [
                { archive = "artifacts.zip"; }
              ];
            };
          };

        darwin = {
          "arm64" = {
            base = [
              { archive = "artifacts.zip"; }
              { archive = "font-subset.zip"; }
            ];
            variants = lib.genAttrs [ "profile" "release" ]
              (variant: [
                { archive = "artifacts.zip"; }
              ]);
          };
          "x64" = {
            base = [
              { archive = "FlutterEmbedder.framework.zip"; }
              { archive = "FlutterMacOS.framework.zip"; }
              { archive = "artifacts.zip"; }
              { archive = "font-subset.zip"; }
              { archive = "gen_snapshot.zip"; }
            ];
            variants.profile = [
              { archive = "FlutterMacOS.framework.zip"; }
              { archive = "artifacts.zip"; }
              { archive = "gen_snapshot.zip"; }
            ];
            variants.release = [
              { archive = "FlutterMacOS.dSYM.zip"; }
              { archive = "FlutterMacOS.framework.zip"; }
              { archive = "artifacts.zip"; }
              { archive = "gen_snapshot.zip"; }
            ];
          };
        };

        ios =
          (lib.genAttrs
            [ "" ]
            (arch:
              {
                base = [
                  { archive = "artifacts.zip"; }
                ];
                variants.profile = [
                  { archive = "artifacts.zip"; }
                ];
                variants.release = [
                  { archive = "artifacts.zip"; }
                  { archive = "Flutter.dSYM.zip"; }
                ];
              }));

        linux = lib.genAttrs
          [ "arm64" "x64" ]
          (arch:
            let
              linux-flutter-gtk = {
                archive = "linux-${arch}-flutter-gtk.zip";
                buildInputs = [ gtk3 ];
              };
            in
            {
              base = [
                ({ archive = "artifacts.zip"; } // lib.optionalAttrs (arch == "arm64") {
                  # For some reason, the arm64 artifacts are missing shader code in Flutter < 3.10.0.
                  postPatch = ''
                    if [ ! -d shader_lib ]; then
                      ln -s ${lib.findSingle
                        (pkg: lib.getName pkg == "flutter-artifact-linux-x64-artifacts")
                        (throw "Could not find the x64 artifact archive.")
                        (throw "Could not find the correct x64 artifact archive.")
                        artifactDerivations.platform.linux.x64.base
                      }/shader_lib .
                    fi
                  '';
                })
                { archive = "font-subset.zip"; }
                (linux-flutter-gtk // {
                  # https://github.com/flutter/flutter/commit/9d94a51b607600a39c14470c35c676eb3e30eed6
                  variant = "debug";
                })
              ];
              variants = lib.genAttrs [ "debug" "profile" "release" ] (variant: [
                linux-flutter-gtk
              ]);
            });
      };
    };

  mkArtifactDerivation = { platform ? null, variant ? null, subdirectory ? null, archive, ... }@args:
    let
      artifactDirectory = if platform == null then null else "${platform}${lib.optionalString (variant != null) "-${variant}"}";
      archiveBasename = lib.removeSuffix ".${(lib.last (lib.splitString "." archive))}" archive;
      overrideUnpackCmd = builtins.elem archive [ "FlutterEmbedder.framework.zip" "FlutterMacOS.framework.zip" ];
    in
    stdenv.mkDerivation ({
      pname = "flutter-artifact${lib.optionalString (platform != null) "-${artifactDirectory}"}-${archiveBasename}";
      version = engineVersion;

      nativeBuildInputs = [ unzip ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

      src =
        if overrideUnpackCmd then
          (fetchurl {
            url = "https://storage.googleapis.com/flutter_infra_release/flutter/${engineVersion}${lib.optionalString (platform != null) "/${artifactDirectory}"}/${archive}";
            hash = (if artifactDirectory == null then hashes else hashes.${artifactDirectory}).${archive};
          }) else
          (fetchzip {
            url = "https://storage.googleapis.com/flutter_infra_release/flutter/${engineVersion}${lib.optionalString (platform != null) "/${artifactDirectory}"}/${archive}";
            stripRoot = false;
            hash = (if artifactDirectory == null then hashes else hashes.${artifactDirectory}).${archive};
          });

      sourceRoot = if overrideUnpackCmd then "." else null;
      unpackCmd = if overrideUnpackCmd then "unzip -o $src -d $out" else null;

      installPhase =
        let
          destination = "$out/${if subdirectory == true then archiveBasename else if subdirectory != null then subdirectory else "."}";
        in
        ''
          # ship the notice near all artifacts. if the artifact directory is / multiple directories are nested in $src, link it there. If there isn't a directory, link it in root
          # this *isn't the same as the subdirectory variable above*
          DIR_CNT="$(echo */ | wc -w)"
          if [[ "$DIR_CNT" == 0 ]]; then
            ln -s ${noticeText} LICENSE.README
          else
            for dir in */
            do
              ln -s ${noticeText} "$dir/LICENSE.README"
            done
          fi
          mkdir -p "${destination}"
          cp -r . "${destination}"
        '';
    } // args);

  artifactDerivations = {
    common = builtins.mapAttrs (name: mkArtifactDerivation) artifacts.common;
    platform =
      builtins.mapAttrs
        (os: architectures:
          builtins.mapAttrs
            (architecture: variants: {
              base = map
                (args: mkArtifactDerivation ({
                  platform = "${os}${lib.optionalString (architecture != "") "-${architecture}"}";
                } // args))
                variants.base;
              variants = builtins.mapAttrs
                (variant: variantArtifacts: map
                  (args: mkArtifactDerivation ({
                    platform = "${os}${lib.optionalString (architecture != "") "-${architecture}"}";
                    inherit variant;
                  } // args))
                  variantArtifacts)
                variants.variants;
            })
            architectures)
        artifacts.platform;
  };
in
artifactDerivations
