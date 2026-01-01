{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
<<<<<<< HEAD
  version = "3.11.4";
=======
  version = "3.11.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ijl";
    repo = "orjson";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-LK3Up6bAWZkou791nrA9iHlgfDLbk196iTn3CBfeyYc=";
=======
    hash = "sha256-oTrmDYmUHXMKxgxzBIStw7nnWXcyH9ir0ohnbX4bdjU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # fix architecture checks in build.rs to fix build for riscv
    ./cross-arch-compat.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-TdZtbb9zR0T+0eauEgRVrDKN2eyCNfEQCJziPlKPWpI=";
=======
    hash = "sha256-y6FmK1RR1DAswVoTlnl19CmoYXAco1dY7lpV/KTypzE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy";
    homepage = "https://github.com/ijl/orjson";
    changelog = "https://github.com/ijl/orjson/blob/${version}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ misuzu ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
