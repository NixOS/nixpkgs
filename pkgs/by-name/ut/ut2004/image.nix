{
  fetchurl,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: rec {
  name = "ut2004-image";

  src = fetchurl {
    urls = [
      "https://files.oldunreal.net/UT2004.ISO"
      "https://files2.oldunreal.net/UT2004.ISO"
      "https://files3.oldunreal.net/UT2004.ISO"
    ];
    hash = "sha256-Q+kYKuILy8D29FiP7mwbM2wmHxRlQDEYoZc7CbGiJUE=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir $out
    cp ${src} $out/ut2004.iso
  '';

  meta = {
    description = "Unreal Tournament 2004 CD image provided by OldUnreal";
    homepage = "https://oldunreal.com/downloads/ut2004/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ corps-fini ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
