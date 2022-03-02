{ lib
, buildPythonPackage
, cryptography
, defusedxml
, fetchFromGitHub
, importlib-resources
, mock
, pyasn1
, pymongo
, pyopenssl
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, requests
, responses
, six
, substituteAll
, xmlschema
, xmlsec
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "7.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uRfcn3nCK+tx6ol6ZFarOSrDOh0cfC9gZXBZ7EICQzw=";
  };

  propagatedBuildInputs = [
    cryptography
    python-dateutil
    defusedxml
    pyopenssl
    pytz
    requests
    six
    xmlschema
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  checkInputs = [
    mock
    pyasn1
    pymongo
    pytestCheckHook
    responses
  ];

  patches = [
    (substituteAll {
      src = ./hardcode-xmlsec1-path.patch;
      inherit xmlsec;
    })
  ];

  postPatch = ''
    # fix failing tests on systems with 32bit time_t
    sed -i 's/2999\(-.*T\)/2029\1/g' tests/*.xml
  '';

  disabledTests = [
    # Disabled tests try to access the network
    "test_load_extern_incommon"
    "test_load_remote_encoding"
    "test_load_external"
    "test_conf_syslog"
  ];

  pythonImportsCheck = [
    "saml2"
  ];

  meta = with lib; {
    description = "Python implementation of SAML Version 2 Standard";
    homepage = "https://github.com/IdentityPython/pysaml2";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
