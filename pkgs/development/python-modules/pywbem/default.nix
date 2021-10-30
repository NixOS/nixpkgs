{ lib, buildPythonPackage, fetchPypi, libxml2
, m2crypto, ply, pyyaml, six, pbr, pythonOlder, isPy37
, nocasedict, nocaselist, yamlloader, requests-mock
, httpretty, lxml, mock, pytest, requests, decorator, unittest2
, FormEncode, testfixtures, pytz
}:

buildPythonPackage rec {
  pname = "pywbem";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ef48185e0adbaeb9bd5181c4c5de951f6d58d54e2e1d7e87a9834e10eabe957";
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
