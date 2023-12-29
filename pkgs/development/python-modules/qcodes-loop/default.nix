{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, h5py
, hickle
, hypothesis
, ipython
, lazy-loader
, matplotlib
, numpy
, pandas
, pyqt5
, pyqtgraph
, pytest-mock
, pytest-xdist
, pytestCheckHook
, pythonOlder
, qcodes
, setuptools
, slack-sdk
, versioningit
, wheel
, xarray
}:

buildPythonPackage rec {
  pname = "qcodes-loop";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "qcodes_loop";
    hash = "sha256-TizNSC49n4Xc2BmJNziARlVXYQxp/LtwmKpgqQkQ3a8=";
  };

  nativeBuildInputs = [
    setuptools
    versioningit
    wheel
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

  pythonImportsCheck = [
    "qcodes_loop"
  ];

  postInstall = ''
    export HOME="$TMPDIR"
  '';

  disabledTests = [
    # AssertionError: False is not true
    "TestHDF5_Format"
  ];

  meta = with lib; {
    description = "Features previously in QCoDeS";
    homepage = "https://github.com/QCoDeS/Qcodes_loop";
    changelog = "https://github.com/QCoDeS/Qcodes_loop/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
    # Some tests fail on this platform
    broken = stdenv.isDarwin;
  };
}
