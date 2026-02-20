{
  fetchzip,
  lib,
}:
let
  /*
    see:
    https://github.com/Mastermindzh/tidal-hifi/blob/master/build/electron-builder.base.yml
     for the expected version
  */
  version = "39.2.4";
in
(fetchzip {
  url = "https://github.com/castlabs/electron-releases/releases/download/v${version}+wvcus/electron-v${version}+wvcus-linux-x64.zip";
  hash = "sha256-i2uoX8RkzHN+j0JjZxmWIP2euJMp8Lv9IUYrrmwP7ww=";
  stripRoot = false;

}).overrideAttrs
  (
    final: _: {
      name = "castlabs-electron-${version}";
      inherit version;
      pname = "castlabs-electron";
      passthru = {
        dist = final.finalPackage.outPath;
        src = final.finalPackage;
      };

      meta = {
        license = lib.licenses.unfreeRedistributable;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    }
  )
