{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, rustPlatform
, cffi

# native dependencies
, libiconv

# tests
, numpy
, psutil
, pytestCheckHook
, python-dateutil
, pytz
, xxhash
, python
}:

buildPythonPackage rec {
  pname = "orjson";
  version = "3.9.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ijl";
    repo = "orjson";
    rev = "refs/tags/${version}";
    hash = "sha256-p6nkzEHFTKCBr7Wte2wvzh1TlzwweADZON8gm2pT224=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-2c8XgQILhAvR8HUqoEIOfYeiV1lR9UyIJXWDuNeVZsE=";
  };

  maturinBuildFlags = [ "--interpreter ${python.executable}" ];

  nativeBuildInputs = [
    cffi
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [
    numpy
    psutil
    pytestCheckHook
    python-dateutil
    pytz
    xxhash
  ];

  pythonImportsCheck = [
    "orjson"
  ];

  meta = with lib; {
    description = "Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy";
    homepage = "https://github.com/ijl/orjson";
    changelog = "https://github.com/ijl/orjson/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ misuzu ];
  };
}
