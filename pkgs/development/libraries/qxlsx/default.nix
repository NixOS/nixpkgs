{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "qxlsx";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "QtExcel";
    repo = "QXlsx";
    rev = "v${version}";
    hash = "sha256-8plnvyb4sQRfEac1TVWgr2yrtAVAPKucgAnsybdUd3U=";
  };

  patches = [
    # Fix header include path
    # https://github.com/QtExcel/QXlsx/pull/279
    (fetchpatch {
      url = "https://github.com/QtExcel/QXlsx/commit/9d6db9efb92b93c3663ccfef3aec05267ba43723.patch";
      hash = "sha256-EbE5CNACAcgENCQh81lBZJ52hCIcBsFhNnYOS0Wr25I=";
    })
  ];

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
