{
  blessed,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pandas,
  pytestCheckHook,
  pythonOlder,
  rich,
  setuptools,
}:

buildPythonPackage rec {
  pname = "objexplore";
  version = "1.5.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kylepollina";
    repo = "objexplore";
    rev = "v${version}";
    hash = "sha256-FFQIiip7pk9fQhjGLxMSMakwoXbzaUjXcbQgDX52dnI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '==' '>='
  '';

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

  meta = with lib; {
    description = "Terminal UI to interactively inspect and explore Python objects";
    homepage = "https://github.com/kylepollina/objexplore";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
