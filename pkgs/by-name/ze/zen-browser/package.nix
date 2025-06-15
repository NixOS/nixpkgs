{
  buildMozillaMach,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  fetchurl,
  git,
  pkg-config,
  python3,
  vips,
  runtimeShell,
  writeScriptBin,
}:

let
  zenVersion = "1.12.5b";
  firefoxVersion = "138.0.3";

  firefoxSrc = fetchurl {
    url = "https://archive.mozilla.org/pub/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
    hash = "sha256-on86tB1jWyodhBgonR3tzWy1MhSMfWPT+Ll8ZkRVE+Q=";
  };

  patchedSrc = buildNpmPackage {
    pname = "firefox-zen-browser-src-patched";
    version = zenVersion;

    src = fetchFromGitHub {
      owner = "zen-browser";
      repo = "desktop";
      rev = zenVersion;
      hash = "sha256-6CovYcJBbR9QtcNqZEC4tmukWTqra1b4VepmO21TwhM=";
      fetchSubmodules = true;
    };

    postUnpack = ''
      tar xf ${firefoxSrc}
      mkdir -p source/engine
      mv firefox-${firefoxVersion} source/engine
    '';

    npmDepsHash = "sha256-NwX8+gpz66dl70QyvEETTgTwyAtlv+OaqGtgpeCvvUY=";

    makeCacheWritable = true;

    nativeBuildInputs = [
      git
      python3
      pkg-config
      (writeScriptBin "sips" ''
        #!${runtimeShell}
        echo >&2 "$@"
      '')
      (writeScriptBin "iconutil" ''
        #!${runtimeShell}
        echo >&2 "$@"
      '')
    ];
    # TODO: this should be in nativeBuildInputs, since sharp is only used during build, but it doesn't seem to be
    # visible in there. why not?
    buildInputs = [
      vips
    ];

    buildPhase = ''
      npm run surfer ci --brand release --display-version ${zenVersion}
      npm run import
      python ./scripts/update_en_US_packs.py
    '';

    installPhase = ''
      cp -r engine $out

      cd $out
      for i in $(find . -type l); do
        realpath=$(readlink $i)
        rm $i
        cp $realpath $i
      done
    '';


    dontFixup = true;
  };
in
(
  (buildMozillaMach {
    pname = "zen-browser";
    packageVersion = zenVersion;
    version = firefoxVersion;
    applicationName = "Zen Browser";
    binaryName = "zen";
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
      changelog = "https://zen-browser.app/release-notes/#${zenVersion}";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [
        matthewpi
        titaniumtown
        eveeifyeve
      ];
      broken = true;
      platforms = lib.platforms.unix;
      mainProgram = "zen";
    };
  }).override
  {
    pgoSupport = false;
    crashreporterSupport = false;
    enableOfficialBranding = false;
  }
).overrideAttrs
  (prev: {
    # Remove patch in nixpkgs already applied upstream
    patches = builtins.filter (
      p: !(lib.hasInfix "firefox-mac-missing-vector-header.patch" p)
    ) prev.patches;
  })

