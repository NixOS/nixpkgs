{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  blessed,
  rich,
  pytestCheckHook,
  pandas
}:

buildPythonPackage rec {
  pname = "objexplore";
  version = "1.5.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kylepollina";
    repo = "objexplore";
    rev = "refs/tags/v${version}";
    hash = "sha256-FFQIiip7pk9fQhjGLxMSMakwoXbzaUjXcbQgDX52dnI=";
  };

  pythonRelaxDeps = [ "blessed" "rich" ];

  build-system = [ setuptools ];

  dependencies = [
    blessed
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
  ];

  pythonImportsCheck = [
    "objexplore"
    "objexplore.cached_object"
    "objexplore.explorer"
    "objexplore.filter"
    "objexplore.help_layout"
    "objexplore.objexplore"
    "objexplore.overview"
    "objexplore.stack"
    "objexplore.utils"
  ];

  meta = {
    description = "Terminal UI to interactively inspect and explore Python objects";
    homepage = "https://github.com/kylepollina/objexplore";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds sigmanificient ];
  };
}
