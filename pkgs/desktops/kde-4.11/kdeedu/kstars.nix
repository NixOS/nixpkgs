{ kde, kdelibs, eigen, xplanet, indilib, pkgconfig }:

kde {

# TODO: wcslib

  buildInputs = [ kdelibs eigen xplanet indilib ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "A KDE graphical desktop planetarium";
  };
}
