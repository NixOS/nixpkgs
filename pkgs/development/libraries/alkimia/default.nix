{ mkDerivation, fetchurl, lib
, extra-cmake-modules, doxygen, graphviz, qtbase, qtwebengine, mpir
, kdelibs4support, plasma-framework, knewstuff, kpackage
}:

mkDerivation rec {
  pname = "alkimia";
  version = "8.1.1";

  src = fetchurl {
    url = "mirror://kde/stable/alkimia/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-lXrcY8C+VN1DPjJoo3MjvlRW5auE7OJ/c6FhapLbhtU=";
  };

  nativeBuildInputs = [ extra-cmake-modules doxygen graphviz ];

  # qtwebengine is not a mandatory dependency, but it adds some features
  # we might need for alkimia's dependents. See:
  # https://github.com/KDE/alkimia/blob/v8.1.1/CMakeLists.txt#L124
  buildInputs = [ qtbase qtwebengine kdelibs4support plasma-framework knewstuff kpackage ];
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
