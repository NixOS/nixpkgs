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
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "335112a0f94532ccbe686db7826ee8d0714b32f65891abf92c0a02f3cb0fc5fd";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/scikit-tda/ripser.py/commit/4baa248994cee9a65d710fac91809bad8ed4e5f1.patch";
      sha256 = "sha256-J/nxMOGOUiBueojJrUlAaXwktHDploYG/XL8/siF2kY=";
    })
  ];

  propagatedBuildInputs = [
    cython
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

  meta = with lib; {
    description = "A Lean Persistent Homology Library for Python";
    homepage = "https://ripser.scikit-tda.org";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
