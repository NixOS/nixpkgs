{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qmake,
  qca-qt5,
}:

stdenv.mkDerivation rec {
  pname = "qoauth";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ayoy";
    repo = "qoauth";
    rev = "v${version}";
    name = "qoauth-${version}.tar.gz";
    hash = "sha256-g1slRMIQe7JKNtnaStWZml2dCKiQi+XLMEwZUTRuUqw=";
  };

  postPatch = ''
    sed -i src/src.pro \
        -e 's/lib64/lib/g' \
        -e '/features.path =/ s|$$\[QMAKE_MKSPECS\]|$$NIX_OUTPUT_DEV/mkspecs|'
  '';

  buildInputs = [
    qtbase
    qca-qt5
  ];
  nativeBuildInputs = [ qmake ];

  env = {
    NIX_CFLAGS_COMPILE = "-I${qca-qt5}/include/Qca-qt5/QtCrypto";
    NIX_LDFLAGS = "-lqca-qt5";
  };

  dontWrapQtApps = true;

  meta = {
    description = "Qt library for OAuth authentication";
    homepage = "https://github.com/ayoy/qoauth";
    inherit (qtbase.meta) platforms;
    license = lib.licenses.lgpl21;
  };
}
