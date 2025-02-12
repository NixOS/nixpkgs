{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  flit-core,
  numpy,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "castepxbin";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zhubonan";
    repo = "castepxbin";
    tag = "v${version}";
    hash = "sha256-6kumVnm4PLRxuKO6Uz0iHzfYuu21hFC7EPRsc3S1kxE=";
  };

  build-system = [ flit-core ];

  pythonRelaxDeps = [
    "numpy"
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Collection of readers for CASTEP binary outputs";
    homepage = "https://github.com/zhubonan/castepxbin";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
