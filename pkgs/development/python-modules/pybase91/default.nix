{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  rustPlatform,
  cargo,
  rustc,
}:

buildPythonPackage rec {
  pname = "pybase91";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "base91";
    rev = "v${version}";
    hash = "sha256-S5gWC2SmN5lAjfFGK0z31ZL//pRXQG2qLk3RMnzuiys=";
  };

  buildAndTestSubdir = "rust/base91";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    pname = "pybase91";
    inherit version;
    sourceRoot = "source/rust";
    hash = "sha256-Xxph31cpLJjHA3EzU0541FM0IIkCTA9HHpWM8IiXHkQ=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  maturinBuildFlags = [
    "--features"
    "python"
  ];

  pythonImportsCheck = [ "pybase91" ];

  meta = {
    description = "basE91 Python extension (Rust/PyO3)";
    homepage = "https://github.com/douzebis/base91";
    changelog = "https://github.com/douzebis/base91/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
  };
}
