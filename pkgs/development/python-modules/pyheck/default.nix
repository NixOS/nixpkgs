{ lib
, buildPythonPackage
, cargo
, fetchFromGitHub
, libiconv
, poetry-core
, pytestCheckHook
, pythonOlder
, rustc
, rustPlatform
, stdenv
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

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

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
