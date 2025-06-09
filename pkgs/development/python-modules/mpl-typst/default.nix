{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  matplotlib,
  numpy,
  pytestCheckHook,
  pillow,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "mpl-typst";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daskol";
    repo = "mpl-typst";
    tag = "v${version}";
    hash = "sha256-Pm5z4tkpgwjYtpBh9+AJWlsHl7HNGxyftfaNSwQDpdk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pillow
    numpy
  ];

  pythonImportsCheck = [
    "mpl_typst"
    "mpl_typst.as_default"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Typst backend for matplotlib";
    homepage = "https://github.com/daskol/mpl-typst";
    changelog = "https://github.com/daskol/mpl-typst/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
