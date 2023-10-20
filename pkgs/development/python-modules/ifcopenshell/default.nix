{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cmake
, boost179
, icu
, swig
, pcre
, gmp
, mpfr
, cgal_5
, opencascade-occt
, opencollada
, libxml2
}:

buildPythonPackage rec {
  pname = "ifcopenshell";
  version = "0.7.0a10";
  format = "other";

  src = fetchFromGitHub {
    owner = "IfcOpenShell";
    repo = "IfcOpenShell";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-wZhdU+yuWNEB2B574q2XAKjQdpvPHR+68hQRkNzhRvc=";
  };

  nativeBuildInputs = [ cmake ];

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
    "-DBUILD_EXAMPLES=OFF"
    "-DENABLE_BUILD_OPTIMIZATIONS=ON"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
    "-DOCC_LIBRARY_DIR=${opencascade-occt}/lib"
    "-DCOLLADA_SUPPORT=ON"
    "-DOPENCOLLADA_INCLUDE_DIR=${opencollada}/include/opencollada"
    "-DOPENCOLLADA_LIBRARY_DIR=${opencollada}/lib/opencollada"
    "-DPCRE_LIBRARY_DIR=${pcre.out}/lib"
    "-DHDF5_SUPPORT=OFF"
    "-DBoost_INCLUDE_DIR=${boost179.dev}/include"
    "-DBoost_LIBRARY_DIR=${boost179}/lib"
    "-DCGAL_INCLUDE_DIR=${cgal_5}/include"
    "-DGMP_LIBRARY_DIR=${gmp}/lib"
    "-DGMP_INCLUDE_DIR=${gmp.dev}/include"
    "-DMPFR_LIBRARY_DIR=${mpfr}/lib"
    "-DMPFR_INCLUDE_DIR=${mpfr.dev}/include"
    "-DSWIG_EXECUTABLE=${swig}/bin/swig"
    "-DLIBXML2_INCLUDE_DIR=${libxml2.dev}/include/libxml2"
    "-DLIBXML2_LIBRARIES=${libxml2.out}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  meta = with lib; {
    description = "Open source IFC library and geometry engine";
    homepage = "http://ifcopenshell.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ fehnomenal ];
  };
}
