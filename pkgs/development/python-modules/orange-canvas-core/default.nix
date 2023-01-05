{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, anyqt
, cachecontrol
, CommonMark
, dictdiffer
, docutils
, lockfile
, qasync
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "orange-canvas-core";
  version = "0.1.28";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "biolab";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9ozjQQK6xJC1qf8tBWLEfnLMLH5Gdqv6ST7zwk6ox+0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    anyqt
    cachecontrol
    CommonMark
    dictdiffer
    docutils
    lockfile
    qasync
  ];

  pythonImportsCheck = [ "orangecanvas" ];

  doCheck = true;

  checkInputs = [
    pytestCheckHook
  ];

   # Other tests fail because Qt modules cannot be imported
  pytestFlagsArray = [
    "orangecanvas/registry/tests/test_base.py"
    "orangecanvas/registry/tests/test_discovery.py"
    "orangecanvas/scheme/tests/test_annotations.py"
    "orangecanvas/scheme/tests/test_signalmanager.py"
    "orangecanvas/utils/tests/test_after_exit.py"
    "orangecanvas/utils/tests/test_graph.py"
    "orangecanvas/utils/tests/test_markup.py"
    "orangecanvas/utils/tests/test_qinvoke.py"
    "orangecanvas/utils/tests/test_qobjref.py"
    "orangecanvas/utils/tests/test_shtools.py"
    "orangecanvas/utils/tests/test_utils.py"
    "orangecanvas/canvas/items/tests/test_utils.py"
  ];

  meta = with lib; {
    description = "A framework for building graphical user interfaces for editing workflows";
    longDescription = ''
      It is a component used to build the Orange Canvas (http://orange.biolab.si) data-mining application
      (for which it was developed in the first place).
    '';
    homepage = "https://orangedatamining.com/";
    changelog = "https://github.com/biolab/orange-canvas-core/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ totoroot ];
  };
}
