{ lib
, buildPythonPackage
, cryptography
, defusedxml
, fetchFromGitHub
, importlib-resources
, poetry-core
, pyasn1
, pymongo
, pyopenssl
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, requests
, responses
, setuptools
, substituteAll
, xmlschema
, xmlsec
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "7.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-f8qd1Mfy32CYH9/PshfMMBviDg7OhOPlwz69bPjlYbg=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-xmlsec1-path.patch;
      inherit xmlsec;
    })
  ];

  postPatch = ''
    # Fix failing tests on systems with 32bit time_t
    sed -i 's/2999\(-.*T\)/2029\1/g' tests/*.xml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cryptography
    defusedxml
    pyopenssl
    python-dateutil
    pytz
    requests
    setuptools
    xmlschema
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    pyasn1
    pymongo
    pytestCheckHook
    responses
  ];

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
    changelog = "https://github.com/IdentityPython/pysaml2/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
