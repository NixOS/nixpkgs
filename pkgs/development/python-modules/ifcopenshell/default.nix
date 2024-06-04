{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gcc10,
  cmake,
  boost179,
  icu,
  swig,
  pcre,
  opencascade-occt_7_6,
  opencollada,
  libxml2,
}:
let
  opencascade-occt = opencascade-occt_7_6;
in
buildPythonPackage rec {
  pname = "ifcopenshell";
  version = "240306";
  format = "other";

  src = fetchFromGitHub {
    owner = "IfcOpenShell";
    repo = "IfcOpenShell";
    rev = "refs/tags/blenderbim-${version}";
    fetchSubmodules = true;
    sha256 = "sha256-DtA8KeWipPfOnztKG/lrgLZeOCUG3nWR9oW7OST7koc=";
  };

  nativeBuildInputs = [
    gcc10
    cmake
  ];

  buildInputs = [
    boost179
    icu
    pcre
    libxml2
  ];

  preConfigure = ''
    cd cmake
  '';

  PYTHONUSERBASE = ".";
  cmakeFlags = [
    "-DUSERSPACE_PYTHON_PREFIX=ON"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
    "-DOCC_LIBRARY_DIR=${opencascade-occt}/lib"
    "-DOPENCOLLADA_INCLUDE_DIR=${opencollada}/include/opencollada"
    "-DOPENCOLLADA_LIBRARY_DIR=${opencollada}/lib/opencollada"
    "-DSWIG_EXECUTABLE=${swig}/bin/swig"
    "-DLIBXML2_INCLUDE_DIR=${libxml2.dev}/include/libxml2"
    "-DLIBXML2_LIBRARIES=${libxml2.out}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Open source IFC library and geometry engine";
    homepage = "http://ifcopenshell.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ fehnomenal ];
  };
}
