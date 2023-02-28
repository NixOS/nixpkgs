{ lib
, stdenv
, pythonOlder
, rustPlatform
, fetchFromGitHub
, buildPythonPackage
, cffi
, libiconv
, numpy
, psutil
, pytestCheckHook
, python-dateutil
, pytz
, xxhash
}:

buildPythonPackage rec {
  pname = "orjson";
  version = "3.8.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ijl";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-LwLuMcnAubO7U1/KSe6tHaSP9+bi6gDfvGobixzL2gM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-8T//q6nQoZhh8oJWDCeQf3gYRew58dXAaxkYELY4CJM=";
  };

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
