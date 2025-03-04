{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  docopt,
  pytz,
  requests,
  setuptools,
  vincenty,
  xmltodict,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "buienradar";
  version = "1.0.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjj4791";
    repo = "python-buienradar";
    # https://github.com/mjj4791/python-buienradar/issues/14
    tag = version;
    hash = "sha256-DwOysdA6B9DMH1j/1Oetx2rCgqwk/UggCdH0lBVS6Hw=";
  };

  propagatedBuildInputs = [
    docopt
    pytz
    requests
    setuptools
    vincenty
    xmltodict
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
