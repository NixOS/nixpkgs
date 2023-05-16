{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, requests
, six
, pytestCheckHook
, pyyaml
}:

buildPythonPackage rec {
  pname = "pynetbox";
<<<<<<< HEAD
  version = "7.1.0";
=======
  version = "7.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-E79n4E386bSxDRzxcjCIvK0Z3r78HsFjGIXqjqQ1zyE=";
=======
    hash = "sha256-RAUM79lDz7oNV7Li987Sz7JoNz/feO6BsEcWO0u/Ub8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  disabledTestPaths = [
    # requires docker for integration test
    "tests/integration"
  ];

  meta = with lib; {
    changelog = "https://github.com/netbox-community/pynetbox/releases/tag/v${version}";
    description = "API client library for Netbox";
    homepage = "https://github.com/netbox-community/pynetbox";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
