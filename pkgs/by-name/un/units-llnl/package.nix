{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  # This is the baseType needed by scipp - the main package that depends on
  # this package.
  baseType ? "uint64_t",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "units-llnl";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "units";
    tag = "v${finalAttrs.version}";
    hash = "sha256-thJnBT+wQPF9obzXk/T6H9lvPEAH5REx3YhBXEd7n7c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];
  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeFeature "UNITS_BASE_TYPE" baseType)
  ];
  doCheck = true;

  meta = {
    description = "Run-time C++ library for working with units of measurement and conversions between them and with string representations of units and measurements";
    homepage = "https://github.com/llnl/units";
    changelog = "https://github.com/llnl/units/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "units-llnl";
    platforms = lib.platforms.all;
  };
})
