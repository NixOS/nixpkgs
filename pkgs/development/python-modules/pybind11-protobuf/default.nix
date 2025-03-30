{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  abseil-cpp_202301,
  protobuf_23,
  pybind11,
}:

buildPythonPackage {
  pname = "pybind11-protobuf";
  version = "0-unstable-2024-11-01";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11_protobuf";
    rev = "90b1a5b9de768340069c15b603d467c21cac5e0b";
    hash = "sha256-3OuwRP9MhxmcfeDx+p74Fz6iLqi9FXbR3t3BtafesKk=";
  };

  patches = [
    (fetchpatch {
      name = "0006-Add-install-target-for-CMake-builds.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11_protobuf/0006-Add-install-target-for-CMake-builds.patch?rev=2";
      hash = "sha256-tjaOr6f+JCRft0SWd0Zfte7FEOYOP7RrW0Vjz34rX6I=";
    })
    (fetchpatch {
      name = "0007-CMake-Use-Python-Module.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11_protobuf/0007-CMake-Use-Python-Module.patch?rev=2";
      hash = "sha256-A1dhfh31FMBHBdCfoYmQrInZvO/DeuVMUL57PpUHYfA=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    abseil-cpp_202301
    protobuf_23
    pybind11
  ];

  meta = {
    description = "Pybind11 bindings for Google's Protocol Buffers";
    homepage = "https://github.com/pybind/pybind11_protobuf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
