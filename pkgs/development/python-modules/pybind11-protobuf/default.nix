{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  abseil-cpp_202407, # downgrade, same reason as toplevel protobuf_29
  protobuf_29,
  pybind11,
  zlib,
}:

buildPythonPackage {
  pname = "pybind11-protobuf";
  version = "0-unstable-2025-02-10";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11_protobuf";
    rev = "f02a2b7653bc50eb5119d125842a3870db95d251";
    hash = "sha256-jlZcxQKYYYvTOGhk+0Sgtek4oKy6R1wDGiBOf2t+KiU=";
  };

  patches = [
    # Rebase of the OpenSUSE patch: https://build.opensuse.org/projects/openSUSE:Factory/packages/pybind11_protobuf/files/0006-Add-install-target-for-CMake-builds.patch?expand=1
    # on top of: https://github.com/pybind/pybind11_protobuf/pull/188/commits/5f0ac3d8c10cbb8b3b81063467c71085cd39624f
    ./add-install-target-for-cmake-builds.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    abseil-cpp_202407
    protobuf_29
    pybind11
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_ABSEIL" true)
    (lib.cmakeBool "USE_SYSTEM_PROTOBUF" true)
    (lib.cmakeBool "USE_SYSTEM_PYBIND" true)

    # The find_package calls are local to the dependencies subdirectory
    (lib.cmakeBool "CMAKE_FIND_PACKAGE_TARGETS_GLOBAL" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Without it, Cmake prefers using Find-module which is mysteriously broken
    # But the generated Config works
    (lib.cmakeBool "CMAKE_FIND_PACKAGE_PREFER_CONFIG" true)
  ];

  meta = {
    description = "Pybind11 bindings for Google's Protocol Buffers";
    homepage = "https://github.com/pybind/pybind11_protobuf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
