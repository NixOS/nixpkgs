{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest
, jinja2
, matplotlib
, nose
, pillow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-mpl";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TTqagfB15FEAxk+VWsEfaELT+B6Tw0wtXFi3wD2kD/0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION=version;

  propagatedBuildInputs = [
    jinja2
    matplotlib
    nose
    pillow
  ];

  checkInputs = [
    pytestCheckHook
  ];


  disabledTests = [
    # Broken since b6e98f18950c2b5dbdc725c1181df2ad1be19fee
    "test_hash_fails"
    "test_hash_missing"
  ];

  disabledTestPaths = [
    # Following are broken since at least a1548780dbc79d76360580691dc1bb4af4e837f6
    "tests/subtests/test_subtest.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/matplotlib
    echo "backend: ps" > $HOME/.config/matplotlib/matplotlibrc
    ln -s $HOME/.config/matplotlib $HOME/.matplotlib
  '';

  meta = with lib; {
    description = "Pytest plugin to help with testing figures output from Matplotlib";
    homepage = "https://github.com/matplotlib/pytest-mpl";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
