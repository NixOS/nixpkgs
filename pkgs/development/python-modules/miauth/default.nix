{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook

# build-system
, setuptools

# dependencies
, bluepy
, cryptography

# tests
, pytestCheckHook
}:

buildPythonPackage {
  pname = "miauth";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dnandha";
    repo = "miauth";
    # Release is not tagged properly, https://github.com/dnandha/miauth/issues/15
    # rev = "refs/tags/${version}";
    rev = "refs/tags/release";
    hash = "sha256-+aoY0Eyd9y7xQTA3uSC6YIZisViilsHlFaOXmhPMcBY=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "cryptography"
  ];

  propagatedBuildInputs = [
    bluepy
    cryptography
  ];

  pythonImportsCheck = [
    "miauth"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Authenticate and interact with Xiaomi devices over BLE";
    homepage = "https://github.com/dnandha/miauth";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
