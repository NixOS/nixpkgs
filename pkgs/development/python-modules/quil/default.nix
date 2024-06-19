{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  rustPlatform,
  numpy,
  pytestCheckHook,
  syrupy,
  libiconv,
}:

buildPythonPackage rec {
  pname = "quil";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    rev = "quil-py/v${version}";
    hash = "sha256-c9nFF74Mr6S2b7NthRVUnarwxFZ9s5RUaoxYruE6QvI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-FNkXdBLfKnrD9aUe25uJHi+TtApgFSCryYCY1r8ebho=";
  };

  buildAndTestSubdir = "quil-py";

  preConfigure = ''
    cargo metadata --offline
  '';

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "numpy" ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # Syrupy snapshot needs to be regenerated
    "test_filter_instructions"
  ];

  meta = {
    changelog = "https://github.com/rigetti/quil-rs/blob/${src.rev}/quil-py/CHANGELOG.md";
    description = "Python package for building and parsing Quil programs";
    homepage = "https://github.com/rigetti/quil-rs/tree/main/quil-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
