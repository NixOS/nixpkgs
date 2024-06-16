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

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zhubonan";
    repo = "castepxbin";
    rev = "refs/tags/v${version}";
    hash = "sha256-6kumVnm4PLRxuKO6Uz0iHzfYuu21hFC7EPRsc3S1kxE=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A collection of readers for CASTEP binary outputs";
    homepage = "https://github.com/zhubonan/castepxbin";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
