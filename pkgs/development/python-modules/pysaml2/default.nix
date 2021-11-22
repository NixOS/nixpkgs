{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, substituteAll
, xmlsec
, cryptography
, defusedxml
, pyopenssl
, python-dateutil
, pytz, requests
, six
, mock
, pyasn1
, pymongo
, pytest
, responses
, xmlschema
, importlib-resources
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "7.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3Yl6j6KAlw7QQYnwU7+naY6D97IqX766zguekKAuic8=";
  };

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
    pytest
    responses
  ];

  # Disabled tests try to access the network
  checkPhase = ''
    py.test -k "not test_load_extern_incommon \
            and not test_load_remote_encoding \
            and not test_load_external \
            and not test_conf_syslog"
  '';

  meta = with lib; {
    description = "Python implementation of SAML Version 2 Standard";
    homepage = "https://github.com/IdentityPython/pysaml2";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
