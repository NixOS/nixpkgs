{ lib
, buildPythonPackage
, fetchPypi
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
  version = "0.40.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "438c1dde5462e68c5c792b7b4a1d87a0ddd970af3db31b3cf15980eed0c44311";
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
