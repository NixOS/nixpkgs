{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  # The upstream default value of this option is simply `units`. However in
  # Nixpkgs the only usage of this package is for scipp which requires _this_
  # namespace. Allowing it
  namespace ? "llnl::units",
  # This is also the baseType needed by scipp
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
  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" true)
      (lib.cmakeFeature "UNITS_BASE_TYPE" baseType)
      # NOTE: Only the default namespace of 'units' and Nixpkgs' default
      # namespace were tested to work. Other random namespaces failed to
      # compile completely.
      (lib.cmakeFeature "UNITS_NAMESPACE" namespace)
      # From some reason these two features don't work well with Nixpkgs'
      # default namespace.
      (lib.cmakeBool "UNITS_BUILD_CONVERTER_APP" false)
      (lib.cmakeBool "UNITS_ENABLE_TESTS" false)
    ]
    # Spares a few warnings, as also mentioned here:
    # https://github.com/scipp/scipp/blob/25.05.0/lib/cmake/.conan-recipes/llnl-units/conanfile.py
    ++ lib.optionals (lib.hasInfix "::" namespace) [
      "-DCMAKE_CXX_STANDARD=17"
    ];
  passthru = {
    inherit namespace;
  };
  doCheck = true;

  meta = {
    description = "A run-time C++ library for working with units of measurement and conversions between them and with string representations of units and measurements";
    homepage = "https://github.com/llnl/units";
    changelog = "https://github.com/llnl/units/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "units-llnl";
    platforms = lib.platforms.all;
  };
})
