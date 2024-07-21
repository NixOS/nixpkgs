{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  asteval,
  dill,
  numpy,
  scipy,
  uncertainties,
  pytestCheckHook,
  pandas,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "lmfit";
  version = "1.3.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mb7q4fAnwbjBTc1/LoSIqAt1+zied/ymd1Sb3C/ll7s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace "--cov=lmfit --cov-report html" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asteval
    dill
    numpy
    scipy
    uncertainties
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    matplotlib
  ];

  meta = with lib; {
    description = "Least-Squares Minimization with Bounds and Constraints";
    homepage = "https://lmfit-py.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nomeata ];
  };
}
