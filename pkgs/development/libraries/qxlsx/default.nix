{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "qxlsx";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "QtExcel";
    repo = "QXlsx";
    rev = "v${version}";
    hash = "sha256-E3x2IUPMRmPSTRN01sXJ0PZaN7iBzatr2vwan2sZxf0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];

  preConfigure = ''
    cd QXlsx
  '';

  dontWrapQtApps = true;

  meta = with lib;{
    description = "Excel file(*.xlsx) reader/writer library using Qt 5 or 6";
    homepage = "https://qtexcel.github.io/QXlsx";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
