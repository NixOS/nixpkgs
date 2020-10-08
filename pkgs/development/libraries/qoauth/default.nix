{ stdenv, fetchurl, qtbase, qmake, qca-qt5 }:

stdenv.mkDerivation {
  name = "qoauth-2.0.0";

  src = fetchurl {
    url = "https://github.com/ayoy/qoauth/archive/v2.0.0.tar.gz";
    name = "qoauth-2.0.0.tar.gz";
    sha256 = "a28005986410d333e03d077679cdf6c504ec5a33342867dc0f9fb0b74285e333";
  };

  postPatch = ''
    sed -i src/src.pro \
        -e 's/lib64/lib/g' \
        -e '/features.path =/ s|$$\[QMAKE_MKSPECS\]|$$NIX_OUTPUT_DEV/mkspecs|'
  '';

  buildInputs = [ qtbase qca-qt5 ];
  nativeBuildInputs = [ qmake ];

  NIX_CFLAGS_COMPILE = "-I${qca-qt5}/include/Qca-qt5/QtCrypto";
  NIX_LDFLAGS = "-lqca-qt5";

  meta = with stdenv.lib; {
    description = "Qt library for OAuth authentication";
    inherit (qtbase.meta) platforms;
    license = licenses.lgpl21;
  };
}
