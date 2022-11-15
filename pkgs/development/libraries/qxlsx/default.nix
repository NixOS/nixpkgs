{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "qxlsx";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "QtExcel";
    repo = "QXlsx";
    rev = "v${version}";
    hash = "sha256-01G7eJRrnee/acEeobYAYMY+93y+I0ASOTVRGuO+IcA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];

  # Don't force Qt definitions onto users: https://github.com/QtExcel/QXlsx/commit/8e83402d
  postPatch = ''
    substituteInPlace QXlsx/CMakeLists.txt \
     --replace 'target_compile_definitions(QXlsx PUBLIC' 'target_compile_definitions(QXlsx PRIVATE'
  '';

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
