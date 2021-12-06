{ lib, buildPythonPackage, fetchPypi, libxml2
, m2crypto, ply, pyyaml, six, pbr, pythonOlder, nocasedict, nocaselist, yamlloader, requests-mock
, httpretty, lxml, mock, pytest, requests, decorator, unittest2
, FormEncode, testfixtures, pytz
}:

buildPythonPackage rec {
  pname = "pywbem";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e4b4cf4813da57a02ce999d5e2e97e7a9f1ec8014e6561a896ee8b14ae5fa4d";
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
  ] ++ lib.optionals (pythonOlder "3.0") [ m2crypto ];

  checkInputs = [
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
    unittest2
  ];

  meta = with lib; {
    description = "Support for the WBEM standard for systems management";
    homepage = "https://pywbem.github.io";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
