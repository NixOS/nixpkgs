{
  buildMozillaMach,
  fetchFromGitHub,
  lib,
  fetchurl,
  stdenvNoCC,
}:

let
  version = "1.17.15b";
  firefoxVersion = "146.0.1";

  zenBrowserSource = fetchFromGitHub {
    owner = "zen-browser";
    repo = "desktop";
    tag = "1.17.15b";
    hash = "sha256-gum8jpA3hyPjasCfZ5KY7ibpB08NIYJhfcVCHitx5Bw";
  };

  patchedSrc = stdenvNoCC.mkDerivation {
    pname = "firefox-browser-src-patched";
    version = firefoxVersion;

    src = fetchurl {
      url = "https://archive.mozilla.org/pub/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    patchPhase = ''
      runHook prePatch

      # Zen-browser Locals
      ls -la .
      exit 1
      mv ${zenBrowserSource}/locals

      runHook postPatch
    '';

    patches = [
      "${zenBrowserSource}/**/**/*.patch" # We need to fetch all zen-browser patches dymanically.
    ];

  };

  # patchedSrc2 = buildNpmPackage {
  #   pname = "firefox-zen-browser-src-patched";
  #   version = zenVersion;
  #
  #   src = fetchFromGitHub {
  #     owner = "zen-browser";
  #     repo = "desktop";
  #     tag = zenVersion;
  #     hash = "sha256-6CovYcJBbR9QtcNqZEC4tmukWTqra1b4VepmO21TwhM=";
  #     fetchSubmodules = true;
  #   };
  #
  #   postUnpack = ''
  #     tar xf ${firefoxSrc}
  #     mkdir -p source/engine
  #     mv firefox-${firefoxVersion} source/engine
  #   '';
  #
  #   npmDepsHash = "sha256-NwX8+gpz66dl70QyvEETTgTwyAtlv+OaqGtgpeCvvUY=";
  #
  #   makeCacheWritable = true;
  #
  #   nativeBuildInputs = [
  #     git
  #     python3
  #     pkg-config
  #     (writeScriptBin "sips" ''
  #       #!${runtimeShell}
  #       echo >&2 "$@"
  #     '')
  #     (writeScriptBin "iconutil" ''
  #       #!${runtimeShell}
  #       echo >&2 "$@"
  #     '')
  #   ];
  #   # TODO: this should be in nativeBuildInputs, since sharp is only used during build, but it doesn't seem to be
  #   # visible in there. why not?
  #   buildInputs = [
  #     vips
  #   ];
  #
  #   buildPhase = ''
  #     npm run surfer ci --brand release --display-version ${zenVersion}
  #     npm run import
  #     python ./scripts/update_en_US_packs.py
  #   '';
  #
  #   installPhase = ''
  #     cp -r engine $out
  #
  #     cd $out
  #     for i in $(find . -type l); do
  #       realpath=$(readlink $i)
  #       rm $i
  #       cp $realpath $i
  #     done
  #   '';
  #
  #   dontFixup = true;
  # };
in
(buildMozillaMach {
  pname = "zen-browser";
  packageVersion = version;
  version = firefoxVersion;
  applicationName = "zen";
  branding = "browser/branding/release";
  requireSigning = false;
  allowAddonSideload = true;

  src = patchedSrc;

  extraConfigureFlags = [
    "--with-app-basename=Zen"
  ];

  meta = {
    description = "Firefox based browser with a focus on privacy and customization";
    homepage = "https://zen-browser.app/";
    downloadPage = "https://zen-browser.app/download/";
    changelog = "https://zen-browser.app/release-notes/#${version}";
    maintainers = with lib.maintainers; [
      matthewpi
      titaniumtown
      eveeifyeve
    ];
    platforms = lib.platforms.unix;
    broken = false; # Broken for now because major issue with getting rid of surfer.
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
  };
}).override
  {
    pgoSupport = false;
    crashreporterSupport = false;
    enableOfficialBranding = false;
  }
