{ lib, stdenv, fetchFromGitHub, qtbase, qmake, qca-qt5 }:

stdenv.mkDerivation rec {
  pname = "qoauth";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ayoy";
    repo = "qoauth";
    rev = "v${version}";
    name = "qoauth-${version}.tar.gz";
    sha256 = "1b2jdqs526ac635yb2whm049spcsk7almnnr6r5b4yqhq922anw3";
  };

  postPatch = ''
    sed -i src/src.pro \
        -e 's/lib64/lib/g' \
        -e '/features.path =/ s|$$\[QMAKE_MKSPECS\]|$$NIX_OUTPUT_DEV/mkspecs|'
  '';

  buildInputs = [ qtbase qca-qt5 ];
  nativeBuildInputs = [ qmake ];

  env.NIX_CFLAGS_COMPILE = "-I${qca-qt5}/include/Qca-qt5/QtCrypto";
  NIX_LDFLAGS = "-lqca-qt5";

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Qt library for OAuth authentication";
    inherit (qtbase.meta) platforms;
    license = licenses.lgpl21;
  };
}
