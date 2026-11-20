{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pythonAtLeast,

  # nativeBuildInputs
  pkg-config,
  pyprojectVersionPatchHook,
  rustc,

  # tests
  numpy,
  pytestCheckHook,
  pytest-benchmark,
  pytest-rerunfailures,
}:

buildPythonPackage (finalAttrs: {
  pname = "gilknocker";
  version = "0.4.2-post3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "gilknocker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GSybOILOP0lwxUPB9a8whQvEPS7OdeHcm0pxky7gwkg=";
  };

  # Fixes:
  #   The 'gilknocker' derivation has version '0.4.2-post3' but .dist-info/METADATA specifies version '0.4.2'
  #
  # `pyprojectVersionPatchHook` does not work as the version is derived from `Cargo.toml`
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail \
        'version = "0.4.2"' \
        'version = "${finalAttrs.version}"'
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-C3rxqmZMSc6SC8bU5VB61x8Xk/crD3o7Nr1xvzv7uqI=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonImportsCheck = [ "gilknocker" ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    pytest-benchmark
    pytest-rerunfailures
  ];

  enabledTestPaths = [
    # skip the benchmarks as they can segfault
    # https://github.com/milesgranger/gilknocker/issues/35
    "tests"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.14") [
    # segfaults
    # https://github.com/milesgranger/gilknocker/issues/35
    "benchmarks"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # depends on an empirically-derived threshold that fails on fast and slow machines.
    # https://github.com/milesgranger/gilknocker/issues/36
    "test_knockknock_busy"
    "test_knockknock_some_gil"
  ];

  pytestFlags = [ "--benchmark-disable" ];

  meta = {
    description = "Knock on the Python GIL, determine how busy it is";
    homepage = "https://github.com/milesgranger/gilknocker";
    changelog = "https://github.com/milesgranger/gilknocker/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      unlicense
    ];
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})
