{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, baloo
, exiv2
, kactivities
, kdelibs4support
, kio
, lcms2
, phonon
, qtsvg
, qtx11extras
}:

kdeApp {
  name = "gwenview";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  propagatedBuildInputs = [
    baloo kactivities kdelibs4support kio qtx11extras exiv2 lcms2 phonon qtsvg
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/gwenview"
  '';
}
