{
  stdenv,
  fetchzip,
  lib,
}:
let
  /*
    see:
    https://github.com/Mastermindzh/tidal-hifi/blob/master/build/electron-builder.base.yml
     for the expected version
  */
  version = "44.5.1";

  sources = {
    x86_64-linux = fetchzip {
      url = "https://github.com/castlabs/electron-releases/releases/download/v${version}+wvcus/electron-v${version}+wvcus-linux-x64.zip";
      hash = "sha256-MkMxqKgTHW5VyrsHRHMHRhA3iO9JXW6+yQ6+cnRfHRQ=";
      stripRoot = false;
    };
    aarch64-linux = fetchzip {
      url = "https://github.com/castlabs/electron-releases/releases/download/v${version}+wvcus/electron-v${version}+wvcus-linux-arm64.zip";
      hash = "sha256-pJIMj22Xef+A5Zrg7RAHlk62RN+nMEHK5P46ZlL+ekg=";
      stripRoot = false;
    };
  };

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
src.overrideAttrs (
  final: _: {
    name = "castlabs-electron-${version}";
    inherit version;
    pname = "castlabs-electron";
    passthru = {
      inherit sources;
      dist = final.finalPackage.outPath;
      src = final.finalPackage;
    };

    meta = {
      license = lib.licenses.unfreeRedistributable;
      platforms = builtins.attrNames sources;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  }
)
