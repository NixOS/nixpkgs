{ mkDerivation, fetchurl, lib
, extra-cmake-modules, doxygen, graphviz, qtbase, qtwebkit, mpir
, kdelibs4support, plasma-framework, knewstuff, kpackage
}:

mkDerivation rec {
  name = "alkimia-${version}";
  version = "8.0.1";

  src = fetchurl {
    url = "mirror://kde/stable/alkimia/${version}/${name}.tar.xz";
    sha256 = "059i6vn36sdq5zn2vqzh4asvvgdgs7n478nk9phvb5gdys01fq7m";
  };

  nativeBuildInputs = [ extra-cmake-modules doxygen graphviz ];

  buildInputs = [ qtbase qtwebkit kdelibs4support plasma-framework knewstuff kpackage ];
  propagatedBuildInputs = [ mpir ];

  meta = {
    description = "Library used by KDE finance applications";
    longDescription = ''
      Alkimia is the infrastructure for common storage and business
      logic that will be used by all financial applications in KDE.

      The target is to share financial related information over
      application bounderies.
    '';
    license = lib.licenses.lgpl21Plus;
    platforms = qtbase.meta.platforms;
  };
}
