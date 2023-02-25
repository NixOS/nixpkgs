{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pythonOlder
, cython
, numpy
, scipy
, scikit-learn
, persim
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ripser";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M1ESoPlFMsy+aG23gm7o0HFLMvZYkav5LAoC88sPxf0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/scikit-tda/ripser.py/commit/4baa248994cee9a65d710fac91809bad8ed4e5f1.patch";
      sha256 = "sha256-J/nxMOGOUiBueojJrUlAaXwktHDploYG/XL8/siF2kY=";
    })
  ];

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
    persim
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

  pythonImportsCheck = [
    "ripser"
  ];

  meta = with lib; {
    description = "A Lean Persistent Homology Library for Python";
    homepage = "https://ripser.scikit-tda.org";
    changelog = "https://github.com/scikit-tda/ripser.py/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
