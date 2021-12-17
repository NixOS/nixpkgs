{ lib, buildPythonPackage, fetchPypi, libxml2
, m2crypto, ply, pyyaml, six, pbr, pythonOlder, nocasedict, nocaselist, yamlloader, requests-mock
, httpretty, lxml, mock, pytest, requests, decorator, unittest2
, FormEncode, testfixtures, pytz
}:

buildPythonPackage rec {
  pname = "pywbem";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5df0af28f81891a3914a12f3a30b11b1981f7b30e09c5a42c011797e7fce9b6a";
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
