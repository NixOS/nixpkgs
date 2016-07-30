{
  stdenv, lib,
  src, version,
  automoc4, cmake, perl, pkgconfig, kdelibs, qimageblitz,
  poppler_qt4, libspectre, libkexiv2, djvulibre, libtiff, freetype,
  ebook_tools
}:

stdenv.mkDerivation {
  name = "okular-${version}";
  inherit src;
  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];
  buildInputs = [
    kdelibs qimageblitz poppler_qt4 libspectre libkexiv2 djvulibre libtiff
    freetype ebook_tools
  ];
  meta = {
    platforms = lib.platforms.linux;
    homepage = "http://www.kde.org";
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
