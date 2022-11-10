{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, scipy
, pytestCheckHook
, matplotlib
, meshio
, pyamg
, autograd
}:

buildPythonPackage rec {
  pname = "scikit-fem";
  version = "7.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kinnala";
    repo = "scikit-fem";
    rev = version;
    sha256 = "sha256-FxTZMkPM1nWstsPBKzmxo8cbQ3e/nUmmrSxrGTJGU2c=";
  };

  propagatedBuildInputs = [
    autograd
    matplotlib
    meshio
    numpy
    pyamg
    scipy
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "skfem" ];

  meta = with lib; {
    description = "Simple finite element assemblers";
    homepage = "https://github.com/kinnala/scikit-fem";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
