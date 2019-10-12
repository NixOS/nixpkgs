{ mkDerivation, fetchurl, lib
, extra-cmake-modules, doxygen, graphviz, qtbase, qtwebkit, mpir
, kdelibs4support, plasma-framework, knewstuff, kpackage
}:

mkDerivation rec {
  pname = "alkimia";
  version = "8.0.2";

  src = fetchurl {
    url = "mirror://kde/stable/alkimia/${version}/${pname}-${version}.tar.xz";
    sha256 = "0al5k9irmg9gsjc234qxjsqfzgzsavl18pspqk78mkp8zlv7fvv1";
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
