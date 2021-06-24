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
  version = "0.40.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Q4wd3lRi5oxceSt7Sh2HoN3ZcK89sxs88VmA7tDEQxE=";
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
    "tests/performance"
  ];

  disabledTests = [
    "test_default_settings_set"
  ];

  pythonImportsCheck = [ "datadog" ];

  meta = with lib; {
    description = "The Datadog Python library";
    license = licenses.bsd3;
    homepage = "https://github.com/DataDog/datadogpy";
  };
}
