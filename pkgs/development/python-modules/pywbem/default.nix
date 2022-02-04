{ lib, buildPythonPackage, fetchPypi, libxml2
, m2crypto, ply, pyyaml, six, pbr, pythonOlder, nocasedict, nocaselist, yamlloader, requests-mock
, httpretty, lxml, mock, pytest, requests, decorator, unittest2
, FormEncode, testfixtures, pytz
}:

buildPythonPackage rec {
  pname = "pywbem";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52f668f7ee1f03bdd80485692b648588b3e1909e2dc0754dceca497f5e9cf059";
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
