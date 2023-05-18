{ lib
, buildPythonPackage
, cryptography
, defusedxml
, fetchFromGitHub
, fetchPypi
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

let
  pymongo3 = pymongo.overridePythonAttrs(old: rec {
    version = "3.12.3";
    src = fetchPypi {
      pname = "pymongo";
      inherit version;
      hash = "sha256-ConK3ABipeU2ZN3gQ/bAlxcrjBxfAJRJAJUoL/mZWl8=";
    };
  });
in buildPythonPackage rec {
  pname = "pysaml2";
  version = "7.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QHAbm6u5oH3O7MEVFE+sW98raquv89KJ8gonk3Yyu/0=";
  };

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
    pymongo3
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
