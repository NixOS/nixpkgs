{ lib
, buildPythonPackage
, cargo
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, rustc
, rustPlatform
}:

buildPythonPackage rec {
  pname = "pyheck";
  version = "0.1.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kevinheavey";
    repo = "pyheck";
    rev = "refs/tags/${version}";
    hash = "sha256-mfXkrCbBaJ0da+taKJvfyU5NS43tYJWqtTUXiCLVoGQ=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    cargo
    poetry-core
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyheck"
  ];

  meta = with lib; {
    description = "Python bindings for heck, the Rust case conversion library";
    homepage = "https://github.com/kevinheavey/pyheck";
    changelog = "https://github.com/kevinheavey/pyheck/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
