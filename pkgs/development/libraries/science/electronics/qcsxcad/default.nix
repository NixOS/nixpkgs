{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  csxcad,
  tinyxml,
  vtkWithQt5,
  qtbase,
}:

mkDerivation {
  pname = "qcsxcad";
  version = "unstable-2023-01-06";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "QCSXCAD";
    rev = "1cde9d560a5000f4c24c249d2dd5ccda12de38b6";
    hash = "sha256-kc9Vnx6jGiQC2K88ZH00b61D/DbWxAIZZwYCsINqtrY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCSXCAD_ROOT_DIR=${csxcad}"
    "-DENABLE_RPATH=OFF"
  ];

  buildInputs = [
    csxcad
    tinyxml
    vtkWithQt5
    qtbase
  ];

  meta = with lib; {
    description = "Qt library for CSXCAD";
    homepage = "https://github.com/thliebig/QCSXCAD";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
