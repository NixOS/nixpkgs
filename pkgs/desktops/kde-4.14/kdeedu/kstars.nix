{ kde, kdelibs, eigen, xplanet, indilib_0_9_9, pkgconfig, qjson }:

kde {

# TODO: wcslib, astrometry

  buildInputs = [ kdelibs eigen xplanet indilib_0_9_9 qjson ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "A KDE graphical desktop planetarium";
  };
}
