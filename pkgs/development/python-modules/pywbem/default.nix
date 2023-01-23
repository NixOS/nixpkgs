{ lib
, buildPythonPackage
, fetchPypi
, libxml2
, m2crypto
, ply
, pyyaml
, six
, pbr
, pythonOlder
, nocasedict
, nocaselist
, yamlloader
, requests-mock
, httpretty
, lxml
, mock
, pytest
, requests
, decorator
, FormEncode
, testfixtures
, pytz
}:

buildPythonPackage rec {
  pname = "pywbem";
  version = "1.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xffkWMJTDGE1j7xjM750+vNmqs546uM3QUMSZ63zJhA=";
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

  meta = with lib; {
    description = "Support for the WBEM standard for systems management";
    homepage = "https://pywbem.github.io";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
