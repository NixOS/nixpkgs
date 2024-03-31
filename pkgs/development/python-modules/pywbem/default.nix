{ lib
, buildPythonPackage
, decorator
, fetchPypi
, formencode
, httpretty
, libxml2
, lxml
, mock
, nocasedict
, nocaselist
, pbr
, ply
, pytest
, pythonOlder
, pytz
, pyyaml
, requests
, requests-mock
, six
, testfixtures
, yamlloader
}:

buildPythonPackage rec {
  pname = "pywbem";
  version = "1.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eN8w3umMUIYgtZm4lR8yKoHGwKnXt4/+XgF7lBfNl7k=";
  };

  propagatedBuildInputs = [
    mock
    nocasedict
    nocaselist
    pbr
    ply
    pyyaml
    six
    yamlloader
  ];

  nativeCheckInputs = [
    decorator
    formencode
    httpretty
    libxml2
    lxml
    pytest
    pytz
    requests
    requests-mock
    testfixtures
  ];

  pythonImportsCheck = [
    "pywbem"
  ];

  meta = with lib; {
    description = "Support for the WBEM standard for systems management";
    homepage = "https://pywbem.github.io";
    changelog = "https://github.com/pywbem/pywbem/blob/${version}/docs/changes.rst";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
