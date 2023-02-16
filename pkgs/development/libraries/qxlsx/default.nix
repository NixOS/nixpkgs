{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "qxlsx";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "QtExcel";
    repo = "QXlsx";
    rev = "v${version}";
    hash = "sha256-T+PUeml4O6uwY6DCAsBer4gDo+nrSGGus+yQv02CJcE=";
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
