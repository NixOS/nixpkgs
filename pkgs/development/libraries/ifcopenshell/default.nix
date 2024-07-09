# TODO format with nixpkgs (comma position ?)
{ lib
, stdenv
, testers
, fetchFromGitHub
, gcc10
, cmake
, cgal
, boost179
, gmp
, icu
, swig
, mpfr
, pcre
, opencascade-occt_7_6
, opencollada
, libxml2
, hdf5
, zlib
, libaec
, python3
}:
let
  opencascade-occt = opencascade-occt_7_6;
in
stdenv.mkDerivation rec {
  pname = "ifcopenshell";
  version = "0.7.0";
  format = "other";

  src = fetchFromGitHub {
    owner  = "IfcOpenShell";
    repo   = "IfcOpenShell";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-DtA8KeWipPfOnztKG/lrgLZeOCUG3nWR9oW7OST7koc=";
  };

  nativeBuildInputs = [ gcc10 cmake python3 ];

  buildInputs = [
    # ifcopenshell needs stdc++
    stdenv.cc.cc.lib
    boost179
    cgal
    gmp
    icu
    mpfr
    pcre
    libxml2
    hdf5
    opencascade-occt
    libaec
  ];

  preConfigure = ''
    cd cmake
  '';

  PYTHONUSERBASE=".";

  # We still build with python to generate ifcopenshell_wrapper.py and ifcopenshell_wrapper.so
  cmakeFlags = [
    "-DUSERSPACE_PYTHON_PREFIX=ON"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_IFCPYTHON=ON"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
    "-DOCC_LIBRARY_DIR=${opencascade-occt}/lib"
    "-DOPENCOLLADA_INCLUDE_DIR=${opencollada}/include/opencollada"
    "-DOPENCOLLADA_LIBRARY_DIR=${opencollada}/lib/opencollada"
    "-DSWIG_EXECUTABLE=${swig}/bin/swig"
    "-DLIBXML2_INCLUDE_DIR=${libxml2.dev}/include/libxml2"
    "-DLIBXML2_LIBRARIES=${libxml2.out}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DGMP_LIBRARY_DIR=${gmp.out}/lib/"
    "-DMPFR_LIBRARY_DIR=${mpfr.out}/lib/"
    # HDF5 support is currently not optional, see https://github.com/IfcOpenShell/IfcOpenShell/issues/1815
    "-DHDF5_SUPPORT=ON"
    "-DHDF5_INCLUDE_DIR=${hdf5.dev}/include/"
    "-DHDF5_LIBRARIES=${hdf5.out}/lib/libhdf5_cpp.so;${hdf5.out}/lib/libhdf5.so;${zlib.out}/lib/libz.so;${libaec.out}/lib/libaec.so;" # /usr/lib64/libsz.so;"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Open source IFC library and geometry engine";
    homepage = "http://ifcopenshell.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ fehnomenal ];
  };

  # TODO enable
  # passthru.tests.version = testers.testVersion {
  #   package = ifcopenshell;
  #   command = "IfcConvert --version";
  #   version = version;
  # };
}
