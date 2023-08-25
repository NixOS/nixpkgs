{ lib
, fetchPypi
, pythonOlder
, buildPythonPackage
, qcodes
, h5py
, lazy-loader
, matplotlib
, numpy
, pandas
, versioningit
, xarray
, hickle
, ipython
, slack-sdk
, hypothesis
, pytest-xdist
, pytest-mock
, pyqtgraph
, pyqt5
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qcodes-loop";
  version = "0.1.1";

  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "qcodes_loop";
    sha256 = "sha256-pDR0Ws8cYQifftdE9dKcSzMxmouFo4tJmQvNanm6zyM=";
  };

  nativeBuildInputs = [
    versioningit
  ];

  propagatedBuildInputs = [
    qcodes
    h5py
    lazy-loader
    matplotlib
    numpy
    pandas
    xarray
    hickle
    ipython
  ];

  passthru.optional-dependencies = {
    qtplot = [
      pyqtgraph
    ];
    slack = [
      slack-sdk
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pytest-xdist
    pytest-mock
    pyqt5
  ];

  pythonImportsCheck = [ "qcodes_loop" ];

  disabledTestPaths = [
    # test broken in 0.1.1, see https://github.com/QCoDeS/Qcodes_loop/pull/25
    "src/qcodes_loop/tests/test_hdf5formatter.py"
  ];

  postInstall = ''
    export HOME="$TMPDIR"
  '';

  meta = with lib; {
    description = "Features previously in QCoDeS";
    homepage = "https://github.com/QCoDeS/Qcodes_loop";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}
