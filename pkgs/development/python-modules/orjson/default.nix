{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  rustPlatform,
  cffi,

  # native dependencies
  libiconv,

  # tests
  numpy,
  psutil,
  pytestCheckHook,
  python-dateutil,
  pytz,
  xxhash,

  # for passthru.tests
  falcon,
  fastapi,
  gradio,
  mashumaro,
  ufolib2,
}:

buildPythonPackage rec {
  pname = "orjson";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ijl";
    repo = "orjson";
    tag = version;
    hash = "sha256-pmp8j6035L46ejDOkz9aQnMdX48MFFmNHM3k5TW6kqM=";
  };

  patches = [
    # fix architecture checks in build.rs to fix build for non x86_64
    ./cross-arch-compat.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-h0zx3D4gVvPhHX4ziXUL4eKJEKlYOAj+9wiRbV2yuRw=";
  };

  nativeBuildInputs = [
    cffi
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [
    numpy
    psutil
    pytestCheckHook
    python-dateutil
    pytz
    xxhash
  ];

  pythonImportsCheck = [ "orjson" ];

  passthru.tests = {
    inherit
      falcon
      fastapi
      gradio
      mashumaro
      ufolib2
      ;
  };

  meta = {
    description = "Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy";
    homepage = "https://github.com/ijl/orjson";
    changelog = "https://github.com/ijl/orjson/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ misuzu ];
  };
}
