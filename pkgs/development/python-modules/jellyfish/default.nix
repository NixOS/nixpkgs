{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  rustc,
  rustPlatform,
  unicodecsv,
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jamesturk";
    repo = "jellyfish";
    rev = version;
    hash = "sha256-xInjoTXYgZuHyvyKm+N4PAwHozE5BOkxoYhRzZnPs3Q=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [
    pytestCheckHook
    unicodecsv
  ];

  pythonImportsCheck = [ "jellyfish" ];

  meta = {
    description = "Python library for doing approximate and phonetic matching of strings";
    homepage = "https://github.com/jamesturk/jellyfish";
    changelog = "https://github.com/jamesturk/jellyfish/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koral ];
  };
}
