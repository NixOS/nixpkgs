{
  kdeApp, lib, kdeWrapper,
  ecm, kdoctools,
  baloo, exiv2, kactivities, kdelibs4support, kio, lcms2, phonon,
  qtsvg, qtx11extras
}:

let
  unwrapped =
    kdeApp {
      name = "gwenview";
      meta = {
        license = with lib.licenses; [ gpl2 fdl12 ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
      nativeBuildInputs = [ ecm kdoctools ];
      propagatedBuildInputs = [
        baloo kactivities kdelibs4support kio qtx11extras exiv2 lcms2 phonon
        qtsvg
      ];
    };
in
kdeWrapper unwrapped { targets = [ "bin/gwenview" ]; }
