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
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JugXm8F+MXa0zVdrn1p3MPhI1RvgUTdo/X8x/ZsnCpY=";
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
