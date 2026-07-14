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
  version = "41.5.0";
in
(fetchzip {
  url = "https://github.com/castlabs/electron-releases/releases/download/v${version}+wvcus/electron-v${version}+wvcus-linux-x64.zip";
  hash = "sha256-LjM80c48AzEwoU8h07qUELTV5jjQeApanaoPZ/szdag=";
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
