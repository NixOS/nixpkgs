{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, csxcad
, tinyxml
, vtk_8_withQt5
, qtbase
}:

mkDerivation {
  pname = "qcsxcad";
  version = "unstable-2020-01-04";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "QCSXCAD";
    rev = "0dabbaf2bc1190adec300871cf309791af842c8e";
    sha256 = "11kbh0mxbdfh7s5azqin3i2alic5ihmdfj0jwgnrhlpjk4cbf9rn";
  };

  outputs = [ "out" "dev" ];

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
    vtk_8_withQt5
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
