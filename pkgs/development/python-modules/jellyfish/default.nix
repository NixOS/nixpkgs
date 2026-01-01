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
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jamesturk";
    repo = "jellyfish";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-jKz7FYzV66TUkJZfWDTy8GXmTZ6SU5jEdtkjYLDfS/8=";
=======
    rev = version;
    hash = "sha256-xInjoTXYgZuHyvyKm+N4PAwHozE5BOkxoYhRzZnPs3Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
