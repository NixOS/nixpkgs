{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "qxlsx";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "QtExcel";
    repo = "QXlsx";
    rev = "v${version}";
    hash = "sha256-twOlAiLE0v7+9nWo/Gd+oiKT1umL3UnG1Xa0zDG7u7s=";
  };

  # patch to fix build with Qt 6.10
  # picked from master
  # remove with next release
  patches = [
    (fetchpatch2 {
      url = "https://github.com/QtExcel/QXlsx/commit/90d762625750c6b2c73f6cd96b633e9158aed72e.patch?full_index=1";
      hash = "sha256-0Roo/r7aV/ldNz9u6P1NtWzZMF0DFEj1bNjUA3qlnoI=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];

  preConfigure = ''
    cd QXlsx
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Excel file(*.xlsx) reader/writer library using Qt 5 or 6";
    homepage = "https://qtexcel.github.io/QXlsx";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
