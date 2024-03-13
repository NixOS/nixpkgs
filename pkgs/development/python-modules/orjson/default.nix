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

# for passthru.tests
, falcon
, fastapi
, gradio
, mashumaro
, ufolib2
}:

buildPythonPackage rec {
  pname = "orjson";
  version = "3.9.15";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ijl";
    repo = "orjson";
    rev = "refs/tags/${version}";
    hash = "sha256-6fcj64d/uFCxaez+xxOdHd+NqILKOPqK+YlxYX7D0DI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-/Aa3saUP4QjSBIS9T8Vd0yggiJn2SIk7dYMA5icb1yA=";
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

  passthru.tests = {
    inherit
      falcon
      fastapi
      gradio
      mashumaro
      ufolib2
    ;
  };

  meta = with lib; {
    description = "Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy";
    homepage = "https://github.com/ijl/orjson";
    changelog = "https://github.com/ijl/orjson/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ misuzu ];
  };
}
