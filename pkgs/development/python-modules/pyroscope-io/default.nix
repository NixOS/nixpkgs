{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-rust,
  rustPlatform,
  rustc,
  cargo,
  pkg-config,
  openssl,
  cmake,
  abseil-cpp,
  python,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyroscope-io";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pyroscope-python";
    tag = "python-${finalAttrs.version}";
    hash = "sha256-e/c4gO8VtznOe60OAceKREgLBURBklGDeUS4UlfaoRY=";
    fetchSubmodules = true;
    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0="url.https://github.com/.insteadOf"
      export GIT_CONFIG_VALUE_0="git@github.com:"
    '';
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'setuptools (>=84.0.0,<84.1.0)' 'setuptools (>=83.0.0,<84.1.0)'
    substituteInPlace dd-trace-py/CMakeLists.txt \
      --replace-fail 'FetchContent_MakeAvailable(absl)' "find_package(absl CONFIG REQUIRED)"
  '';

  build-system = [
    setuptools
    setuptools-rust
    rustPlatform.cargoSetupHook
    rustc
    cargo
    pkg-config
    cmake
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    openssl
    abseil-cpp
  ];

  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    cargoRoot = "rust";
    hash = "sha256-yOlesb4jSzzpo1sg6vfaS+conPUAgyc+okQZ++EntYE=";
  };

  doCheck = false; # requires Go

  pythonImportsCheck = [ "pyroscope_io" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/${python.sitePackages}/pyroscope/_native.*.so \
      --add-needed ${abseil-cpp}/lib/libabsl_raw_hash_set.so.*
  '';

  meta = {
    description = "Pyroscope continuous profiling agent for Python applications";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.fliegendewurst ];
  };
})
