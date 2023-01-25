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
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4mqwMkR17lMp10lx+UK0sxW2rA7a8njnDha1YDJ475g=";
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
