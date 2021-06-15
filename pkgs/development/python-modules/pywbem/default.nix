{ lib, buildPythonPackage, fetchPypi, libxml2
, m2crypto, ply, pyyaml, six, pbr, pythonOlder, isPy37
, nocasedict, nocaselist, yamlloader, requests-mock
, httpretty, lxml, mock, pytest, requests, decorator, unittest2
, FormEncode, testfixtures, pytz
}:

buildPythonPackage rec {
  pname = "pywbem";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2abb6443f4debae56af7abefadb9fa5b8af9b53fc9bcf67f6c01a78db1064300";
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
