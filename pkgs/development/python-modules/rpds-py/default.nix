{
  stdenv,
  lib,
  buildPythonPackage,
  cargo,
  fetchPypi,
  pytestCheckHook,
  rustc,
  rustPlatform,
  libiconv,
}:

buildPythonPackage rec {
  pname = "rpds-py";
  version = "2026.9.1";
  pyproject = true;

  src = fetchPypi {
    pname = "rpds_py";
    inherit version;
    hash = "sha256-R5Pvf3gmixJLc/qTNEDwHSWLuuAd6fpT6QgMmrBCWhI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ffIVY9j7qLqvZ9V4xCQTtvjtlKUKegiyt8HbYorVE3s=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rpds" ];

  meta = {
    changelog = "https://github.com/crate-py/rpds/releases/tag/v${version}";
    description = "Python bindings to Rust's persistent data structures";
    homepage = "https://github.com/crate-py/rpds";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
