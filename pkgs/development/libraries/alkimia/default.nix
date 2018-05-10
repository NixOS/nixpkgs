{ mkDerivation, fetchurl, lib
, extra-cmake-modules, doxygen, graphviz, qtbase, mpir
}:

mkDerivation rec {
  name = "alkimia-${version}";
  version = "7.0.1";

  src = fetchurl {
    url = "mirror://kde/stable/alkimia/${version}/src/${name}.tar.xz";
    sha256 = "1fri76465058fgsyrmdrc3hj1javz4g10mfzqp5rsj7qncjr1i22";
  };

  nativeBuildInputs = [ extra-cmake-modules doxygen graphviz ];

  buildInputs = [ qtbase ];
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
