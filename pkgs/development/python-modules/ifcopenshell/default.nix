{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, python
, gcc10
, cmake
, boost172
, icu
, swig
, pcre
, opencascade-occt
, opencollada
, libxml2
}:

buildPythonPackage rec {
  pname = "ifcopenshell";
  version = "0.6.0b0";
  format = "other";

  src = fetchFromGitHub {
    owner  = "IfcOpenShell";
    repo   = "IfcOpenShell";
    rev    = "v${version}";
    fetchSubmodules = true;
    sha256 = "1ad1s9az41z2f46rbi1jnr46mgc0q4h5kz1jm9xdlwifqv9y04g1";
  };

  patches = [
    (substituteAll {
      name = "site-packages.patch";
      src = ./site-packages.patch;
      site_packages = "lib/${python.libPrefix}/site-packages";
    })
  ];

  nativeBuildInputs = [ gcc10 cmake ];

  buildInputs = [
    boost172
    icu
    pcre
    libxml2
  ];

  preConfigure = ''
    cd cmake
  '';

  cmakeFlags = [
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
    "-DOCC_LIBRARY_DIR=${opencascade-occt}/lib"
    "-DOPENCOLLADA_INCLUDE_DIR=${opencollada}/include/opencollada"
    "-DOPENCOLLADA_LIBRARY_DIR=${opencollada}/lib/opencollada"
    "-DSWIG_EXECUTABLE=${swig}/bin/swig"
    "-DLIBXML2_INCLUDE_DIR=${libxml2.dev}/include/libxml2"
    "-DLIBXML2_LIBRARIES=${libxml2.out}/lib/${if stdenv.isDarwin then "libxml2.dylib" else "libxml2.so"}"
  ];

  meta = with lib; {
    description = "Open source IFC library and geometry engine";
    homepage    = http://ifcopenshell.org/;
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ fehnomenal ];
  };
}
