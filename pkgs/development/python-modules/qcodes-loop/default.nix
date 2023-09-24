{ lib
, stdenv
, fetchpatch
, fetchPypi
, pythonOlder
, buildPythonPackage
, qcodes
, h5py
, lazy-loader
, matplotlib
, numpy
, pandas
, setuptools
, versioningit
, wheel
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
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "qcodes_loop";
    hash = "sha256-pDR0Ws8cYQifftdE9dKcSzMxmouFo4tJmQvNanm6zyM=";
  };

  patches = [
    # https://github.com/QCoDeS/Qcodes_loop/pull/39
    (fetchpatch {
      name = "relax-versioningit-dependency.patch";
      url = "https://github.com/QCoDeS/Qcodes_loop/commit/58006d3fb57344ae24dd44bceca98004617b5b57.patch";
      hash = "sha256-mSlm/Ql8e5xPL73ifxSoVc9+U58AAcAmBkdW5P6zEsg=";
    })
  ];

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
    # Some tests fail on this platform
    broken = stdenv.isDarwin;
  };
}
