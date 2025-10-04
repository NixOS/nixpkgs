{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  appdirs,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pypjlink2";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benoitlouy";
    repo = "pypjlink";
    tag = "v${version}";
    hash = "sha256-0RVI9DX5JaVWntSu5du5SU45NC70TZJyVrvMuVR7grA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    appdirs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pypjlink"
  ];

  meta = {
    description = "Python implementation of the PJLink protocol for controlling digital projectors";
    homepage = "https://github.com/benoitlouy/pypjlink";
    changelog = "https://github.com/benoitlouy/pypjlink/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
