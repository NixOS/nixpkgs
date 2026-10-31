{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "patiencediff";
    tag = "v${version}";
    hash = "sha256-ttS4PDhuk6B7KNB9S6vVNWCMB+dY9JV4jGxRHP78kPk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-/AtBPNwwwWH1+e0hPSYKBuXqQ440vgFHFiRL9W/Q8KE=";
  };

  # make rust bindings non-optional
  env.CIBUILDWHEEL = "1";

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  build-system = [
    setuptools
    setuptools-rust
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "patiencediff" ];

  meta = {
    description = "C implementation of patiencediff algorithm for Python";
    mainProgram = "patiencediff";
    homepage = "https://github.com/breezy-team/patiencediff";
    changelog = "https://github.com/breezy-team/patiencediff/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ wildsebastian ];
  };
}
