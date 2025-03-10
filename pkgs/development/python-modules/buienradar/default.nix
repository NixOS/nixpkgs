{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  docopt,
  pytz,
  requests,
  requests-mock,
  setuptools,
  vincenty,
  xmltodict,
  syrupy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "buienradar";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjj4791";
    repo = "python-buienradar";
    tag = version;
    hash = "sha256-DTdxzBe9fBOH5fHME++oq62xMtBKnjY7BCevwjl8VZ8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docopt
    pytz
    requests
    setuptools
    vincenty
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
    syrupy
  ];

  pytestFlagsArray = [ "--snapshot-update" ];

  disabledTests = [
    # require network connection
    "test_rain_data"
    "test_json_data"
    "test_xml_data"
  ];

  pythonImportsCheck = [
    "buienradar.buienradar"
    "buienradar.constants"
  ];

  meta = with lib; {
    changelog = "https://github.com/mjj4791/python-buienradar/blob/${src.tag}/CHANGLOG.rst";
    description = "Library and CLI tools for interacting with buienradar";
    mainProgram = "buienradar";
    homepage = "https://github.com/mjj4791/python-buienradar";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
