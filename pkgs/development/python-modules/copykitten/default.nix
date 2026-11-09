{
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  lib,
  pillow,
}:

buildPythonPackage (finalAttrs: {
  pname = "copykitten";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Klavionik";
    repo = "copykitten";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PFRKEPQ4XfiPmg+YZa+V1FON+IOwXwNxLBwOfsLl1NU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gaad4F3rTIqJf38xZleKduM1M6KdANmItm8bk1iDz4I=";
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
    changelog = "https://github.com/Klavionik/copykitten/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.samasaur ];
    platforms = lib.platforms.all;
  };
})
