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
  version = "0-unstable-2024-01-04";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11_protobuf";
    rev = "3b11990a99dea5101799e61d98a82c4737d240cc";
    hash = "sha256-saeBxffAbDoHI/YvLatSubpdch9vb5DAfp/Bz3MC8ps=";
  };

  patches = [
    (fetchpatch {
      name = "0001-Make-protobuf-python_api-fully-optional.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11_protobuf/0001-Make-protobuf-python_api-fully-optional.patch?rev=1";
      hash = "sha256-gUeM/7R2kC5DaGKtot9AyG9CyCUHZt5s88dfEtj4b5E=";
    })
    (fetchpatch {
      name = "0002-Add-ENABLE_PYPROTO_API-option-to-CMake-build-clean-u.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11_protobuf/0002-Add-ENABLE_PYPROTO_API-option-to-CMake-build-clean-u.patch?rev=1";
      hash = "sha256-2Wh8XxVXD/RBmkVP4XTJt8gCWrn/zII9h2Cjo6n6dI0=";
    })
    (fetchpatch {
      name = "0003-Make-the-pybind11_-_proto_caster-libraries-STATIC.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11_protobuf/0003-Make-the-pybind11_-_proto_caster-libraries-STATIC.patch?rev=1";
      hash = "sha256-4sa3TD9qjEjHFhxZa/87fiWLJhehNYY2xc3i0jeSHeA=";
    })
    (fetchpatch {
      name = "0004-Fix-handling-of-external-dependencies-allow-forcing-.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11_protobuf/0004-Fix-handling-of-external-dependencies-allow-forcing-.patch?rev=1";
      hash = "sha256-ifqOVU/Lzed+B+8rL6u12TjopA3iYPYDW05QV6W9SAQ=";
    })
    (fetchpatch {
      name = "0005-Build-and-run-the-test-cases.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11_protobuf/0005-Build-and-run-the-test-cases.patch?rev=1";
      hash = "sha256-xTiTGS6AsXCJBcyno7IfQd7P7wH51XoeMCEiT6OcUUY=";
    })
    (fetchpatch {
      name = "0006-Add-install-target-for-CMake-builds.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11_protobuf/0006-Add-install-target-for-CMake-builds.patch?rev=1";
      hash = "sha256-2gJgQGFMB7ihftv4vKEe+ES0wofwaCSzsQm3cAAzXrg=";
    })
    (fetchpatch {
      name = "0007-CMake-Use-Python-Module.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11_protobuf/0007-CMake-Use-Python-Module.patch?rev=1";
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
