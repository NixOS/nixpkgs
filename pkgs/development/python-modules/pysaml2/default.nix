{ lib
, buildPythonPackage
, cryptography
, defusedxml
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
buildPythonPackage rec {
  pname = "pysaml2";
  version = "7.4.2";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
<<<<<<< HEAD
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

=======
    rev = "v${version}";
    hash = "sha256-QHAbm6u5oH3O7MEVFE+sW98raquv89KJ8gonk3Yyu/0=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    pymongo
=======
    pymongo3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
    responses
  ];

<<<<<<< HEAD
=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/IdentityPython/pysaml2/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
