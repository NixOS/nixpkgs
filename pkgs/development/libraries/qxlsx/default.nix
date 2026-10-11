{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "qxlsx";
  version = "1.5.1.1";

  src = fetchFromGitHub {
    owner = "QtExcel";
    repo = "QXlsx";
    rev = "v${version}";
    hash = "sha256-jhTRI/6bBNc8cai9AUe9B2PDXwIpTGP4Csa3nZfmLts=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase ];

  preConfigure = ''
    cd QXlsx
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Excel file(*.xlsx) reader/writer library using Qt 5 or 6";
    homepage = "https://qtexcel.github.io/QXlsx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
