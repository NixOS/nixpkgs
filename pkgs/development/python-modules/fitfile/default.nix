{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fitfile";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tcgoetz";
    repo = "fit";
    tag = version;
    hash = "sha256-NIshX/IkPmqviYRPT4wRF7evZwn9e7BdCI5x+2Pz7II=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fitfile" ];

  meta = {
    description = "Python Fit file parser";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/tcgoetz/fit";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
