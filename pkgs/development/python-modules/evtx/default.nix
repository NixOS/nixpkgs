{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, rustPlatform
, libiconv
}:

buildPythonPackage rec {
  pname = "evtx";
  version = "0.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "pyevtx-rs";
    rev = "refs/tags/${version}";
    hash = "sha256-t//oNvD+7wnv5KkriKBX4xgGS8pQpZgCsKxAEXsj0X8=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pyo3-file-0.6.0" = "sha256-lTCaVb4w4rhR3RYya/lcNeGlAtnHQbe/VelEh/vM9PQ=";
    };
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "evtx"
  ];

  meta = with lib; {
    description = "Bindings for evtx";
    homepage = "https://github.com/omerbenamram/pyevtx-rs";
    changelog = "https://github.com/omerbenamram/pyevtx-rs/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
