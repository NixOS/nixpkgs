{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, gcc10
, cmake
, boost17x
, icu
, swig
, pcre
, gmp
, mpfr
, opencascade-occt
, opencollada
, libxml2
, cgal
}:

buildPythonPackage rec {
  pname = "ifcopenshell";
  version = "220707";
  format = "other";

  src = fetchFromGitHub {
    owner  = "IfcOpenShell";
    repo   = "IfcOpenShell";
    rev    = "blenderbim-${version}";
    fetchSubmodules = true;
    sha256 = "sha256-CtxcXU6FawpjMy5QXuhSsN+Dusk9t15uw0rAc9Bljac=";
  };

  nativeBuildInputs = [
    gcc10
    cmake
  ];

  buildInputs = [
    boost17x
    icu
    pcre
    libxml2
    cgal
  ];

  preConfigure = ''
    cd cmake
  '';

  PYTHONUSERBASE=".";
  cmakeFlags = [
    "-DUSERSPACE_PYTHON_PREFIX=ON"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
    "-DOCC_LIBRARY_DIR=${opencascade-occt}/lib"
    "-DOPENCOLLADA_INCLUDE_DIR=${opencollada}/include/opencollada"
    "-DOPENCOLLADA_LIBRARY_DIR=${opencollada}/lib/opencollada"
    "-DSWIG_EXECUTABLE=${swig}/bin/swig"
    "-DLIBXML2_INCLUDE_DIR=${libxml2.dev}/include/libxml2"
    "-DLIBXML2_LIBRARIES=${libxml2.out}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DGMP_INCLUDE_DIR=${gmp}/include"
    "-DGMP_LIBRARY_DIR=${gmp}/lib"
    "-DMPFR_INCLUDE_DIR=${mpfr}/include"
    "-DMPFR_LIBRARY_DIR=${mpfr}/lib"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Open source IFC library and geometry engine";
    homepage    = "http://ifcopenshell.org/";
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ fehnomenal ];
  };
}
