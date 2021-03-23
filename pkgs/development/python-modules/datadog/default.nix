{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, decorator
, requests
, typing
, configparser
, click
, freezegun
, mock
, pytestCheckHook
, pytest-vcr
, python-dateutil
, vcrpy
}:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.39.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0ef69a27aad0e4412c1ac3e6894fa1b5741db735515c34dfe1606d8cf30e4e5";
  };

  postPatch = ''
    find . -name '*.pyc' -exec rm {} \;
  '';

  propagatedBuildInputs = [ decorator requests ]
    ++ lib.optional (pythonOlder "3.5") typing
    ++ lib.optional (pythonOlder "3.0") configparser;

  checkInputs = [
    click
    freezegun
    mock
    pytestCheckHook
    pytest-vcr
    python-dateutil
    vcrpy
  ];

  disabledTestPaths = [
    "tests/unit/dogstatsd/test_statsd.py" # does not work in sandbox
  ];

  disabledTests = [
    "test_default_settings_set"
    "test_threadstats_thread_safety"
  ];

  pythonImportsCheck = [ "datadog" ];

  meta = with lib; {
    description = "The Datadog Python library";
    license = licenses.bsd3;
    homepage = "https://github.com/DataDog/datadogpy";
  };
}
