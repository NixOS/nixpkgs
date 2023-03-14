{ lib
, buildPythonPackage
, cryptography
, defusedxml
, fetchFromGitHub
, fetchPypi
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
, setuptools
, six
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
      sha256 = "sha256-ConK3ABipeU2ZN3gQ/bAlxcrjBxfAJRJAJUoL/mZWl8=";
    };
  });
in buildPythonPackage rec {
  pname = "pysaml2";
  version = "7.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lnaizwbtBYdKx1puizah+UWsw54NVW6UhEw/eStl1WI=";
  };

  propagatedBuildInputs = [
    cryptography
    defusedxml
    pyopenssl
    python-dateutil
    pytz
    requests
    setuptools
    six
    xmlschema
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    mock
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
