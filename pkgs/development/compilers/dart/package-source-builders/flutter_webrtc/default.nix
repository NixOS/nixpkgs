{
  applyPatches,
  fetchzip,
  lib,
  libdrm,
  libgbm,
  pulseaudio,
  stdenvNoCC,
}:
{ version, src, ... }:
let
  # if nixpkgs allowed IFD, we could just read the necessary libwebrtc directly
  # from flutter-webrtc's sources, but unfortunately we can't... so we manually
  # record that info (libwebrtc version but also hashes of each) into one JSON file
  libwebrtc-info = lib.importJSON ./libwebrtc-info.json;

  # note: we can't use pkgs.livekit-libwebrtc because it might not be
  #       the version wanted by this flutter_webrtc version, so we
  #       instead have to download the vendor-compiled versions. sucks :(
  libwebrtc =
    let
      info =
        libwebrtc-info.${version} or (throw ''
            Unsupported version of pub package 'flutter_webrtc': ${version}

            Please add the corresponding libwebrtc version and hashes to:
              pkgs/development/compilers/dart/package-source-builders/flutter_webrtc/libwebrtc-info.json

          To do it semi-automatically, you can use the adjacent 'fetch-webrtc-version.sh' script.
          You can use like this, to fetch the new version's info and then update the libwebrtc-info file:
            jq -s add ./libwebrtc-info.json <(./fetch-webrtc-version.sh '${version}') | sponge ./libwebrtc-info.json
        '');

      # note: if you add a new platform here, you'll need to add it to the list in fetch-webrtc-version
      #       (and also re-gen the JSON file to support it) ((and update meta.platforms))
      arch =
        {
          x86_64-linux = "linux-x64";
          aarch64-linux = "linux-arm64";
        }
        .${stdenvNoCC.hostPlatform.system} or (throw ''
          Package 'flutter_webrtc' is not supported on ${stdenvNoCC.hostPlatform} platforms.
        '');

      url = "https://github.com/webrtc-sdk/libwebrtc/releases/download/${info.version}/libwebrtc-${arch}-release.zip";
      hash = info.hashes.${arch};
    in
    applyPatches {
      pname = "libwebrtc";
      inherit version;

      src = fetchzip {
        inherit version url hash;
        meta = {
          platforms = lib.intersectLists lib.platforms.linux (lib.platforms.x86_64 ++ lib.platforms.aarch64);
          sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
        };
      };

      postPatch = ''
        patchelf lib/libwebrtc.so --add-rpath ${
          lib.makeLibraryPath [
            libdrm
            libgbm
          ]
        }
      '';
    };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "flutter_webrtc";
  inherit version src;

  passthru = src.passthru // {
    inherit libwebrtc;
  };

  propagatedBuildInputs = [ pulseaudio.dev ];

  postPatch = ''
    substituteInPlace third_party/CMakeLists.txt \
      --replace-fail "\''${LIBWEBRTC_THIRD_PARTY_DIR}/downloads/\''${LIBWEBRTC_ASSET}.zip" ${finalAttrs.passthru.libwebrtc}
    ln -s ${finalAttrs.passthru.libwebrtc} third_party/libwebrtc
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./ -T "$out/"

    runHook postInstall
  '';

  # we only patch the linux cmake (and currently libwebrtc is only vendored for linux anyway)
  meta.platforms = lib.platforms.linux;
})
