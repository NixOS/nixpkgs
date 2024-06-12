{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  numpy,
  persim,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  scipy,
}:

buildPythonPackage rec {
  pname = "ripser";
  version = "0.6.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J5ctOvGtmg/e2ls7fN59LR4AbHedC9gKk6f8jIDIoFI=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
    persim
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

  pythonImportsCheck = [ "ripser" ];

  meta = with lib; {
    description = "Lean Persistent Homology Library for Python";
    homepage = "https://ripser.scikit-tda.org";
    changelog = "https://github.com/scikit-tda/ripser.py/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
