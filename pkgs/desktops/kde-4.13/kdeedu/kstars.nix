{ kde, kdelibs, eigen2, xplanet, indilib, pkgconfig }:

kde {

# TODO: wcslib, astrometry

  buildInputs = [ kdelibs eigen2 xplanet indilib ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "A KDE graphical desktop planetarium";
  };
}
