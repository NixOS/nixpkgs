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

buildPythonPackage {
  pname = "objexplore";
  version = "1.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kylepollina";
    repo = "objexplore";
    # tags for >1.5.4 are not availables on github
    # see: https://github.com/kylepollina/objexplore/issues/25
    rev = "3c2196d26e5a873eed0a694cddca66352ea7c81e";
    hash = "sha256-BgeuRRuvbB4p99mwCjNxm3hYEZuGua8x2GdoVssQ7eI=";
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
