{ lib
, buildPythonPackage
, decorator
, fetchPypi
, FormEncode
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
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4mqwMkR17lMp10lx+UK0sxW2rA7a8njnDha1YDJ475g=";
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
    FormEncode
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
    maintainers = with maintainers; [ peterhoeg ];
  };
}
