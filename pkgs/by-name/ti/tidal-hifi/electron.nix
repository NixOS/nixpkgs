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
<<<<<<< HEAD
  version = "39.2.4";
in
(fetchzip {
  url = "https://github.com/castlabs/electron-releases/releases/download/v${version}+wvcus/electron-v${version}+wvcus-linux-x64.zip";
  hash = "sha256-i2uoX8RkzHN+j0JjZxmWIP2euJMp8Lv9IUYrrmwP7ww=";
=======
  version = "37.2.5";
in
(fetchzip {
  url = "https://github.com/castlabs/electron-releases/releases/download/v${version}+wvcus/electron-v${version}+wvcus-linux-x64.zip";
  hash = "sha256-mRbweXYfsWxu7I+pqtBjgA0n+ad2iFawVbDUBT5+LZo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  stripRoot = false;

}).overrideAttrs
  (
    final: _: {
      name = "castlabs-electron-${version}";
      inherit version;
      pname = "castlabs-electron";
      passthru.dist = final.finalPackage.outPath;

      meta = {
        license = lib.licenses.unfreeRedistributable;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    }
  )
