{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-mimeparse";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "falconry";
    repo = "python-mimeparse";
    tag = version;
    hash = "sha256-4LdfxVOioiyjeZjxCrvOELG+mJ4YOX4CUn+CXYWCtOo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
    homepage = "https://github.com/dbtsai/python-mimeparse";
    changelog = "https://github.com/falconry/python-mimeparse/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
