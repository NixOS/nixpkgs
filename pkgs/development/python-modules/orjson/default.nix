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
  version = "3.13.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ijl";
    repo = "orjson";
    tag = version;
    hash = "sha256-AFHhZWHDAmSH1TFm4YOnUCpXaAmTgbjPus3GnMTSqA4=";
  };

  patches = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # fix architecture checks in build.rs to fix build for non x86_64
    ./cross-arch-compat.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-2D+P3TyJkJuLexikbwJZ9Og9dIoQVEKTtIp3xPT2VYM=";
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
