{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, decorator
, requests
, typing ? null
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
  version = "0.42.0";

  src = fetchFromGitHub {
     owner = "DataDog";
     repo = "datadogpy";
     rev = "v0.42.0";
     sha256 = "0xvpsp9jc6hij8j9llnk5irrli494k2k8382g6yljdi241v2izzq";
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
