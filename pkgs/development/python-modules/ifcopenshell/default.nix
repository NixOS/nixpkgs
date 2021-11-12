{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, gcc10
, cmake
, boost17x
, icu
, swig
, pcre
, opencascade-occt
, opencollada
, libxml2
}:

buildPythonPackage rec {
  pname = "ifcopenshell";
  version = "210410";
  format = "other";

  src = fetchFromGitHub {
    owner  = "IfcOpenShell";
    repo   = "IfcOpenShell";
    rev    = "blenderbim-${version}";
    fetchSubmodules = true;
    sha256 = "1g52asxrqcfj01iqvf03k3bb6rg3v04hh1wc3nmn329a2lwjbxpw";
  };

  nativeBuildInputs = [ gcc10 cmake ];

  buildInputs = [
    boost17x
    icu
    pcre
    libxml2
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
  ];

  meta = with lib; {
    description = "Open source IFC library and geometry engine";
    homepage    = "http://ifcopenshell.org/";
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ fehnomenal ];
  };
}
