{
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  lib,
  pillow,
}:

buildPythonPackage rec {
  pname = "copykitten";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Klavionik";
    repo = "copykitten";
    tag = "v${version}";
    hash = "sha256-S4IPVhYk/o15LQK1AB8VpdrHwIwTZyvmI2+e27/vDLs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-kWhZzX/OI+05rvVFD+lOFvpKbNH/gMROFufcCzYDyko=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    pillow
  ];

  # The tests get/set the contents of the clipboard by running subprocesses.
  # On Darwin, the tests try to use `pbcopy`/`pbpaste`, which aren't packaged in Nix.
  # On Linux, I tried adding `xclip` to `nativeCheckInputs`, but got errors about
  # displays being null and the clipboard never being initialized.
  doCheck = false;

  pythonImportsCheck = [ "copykitten" ];

  meta = {
    description = "Robust, dependency-free way to use the system clipboard in Python";
    homepage = "https://github.com/Klavionik/copykitten";
    changelog = "https://github.com/Klavionik/copykitten/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.samasaur ];
    platforms = lib.platforms.all;
  };
}
