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
  version = "0.2.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "patiencediff";
    tag = "v${version}";
    hash = "sha256-xynrYf5oCIPk22jqjvXNYTyaXzVaUjRpn35vbx+t8vU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-JW2Oj1oxAVf9K3lyJQpbHqw9eeNYDg3Agb189bduqlI=";
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
