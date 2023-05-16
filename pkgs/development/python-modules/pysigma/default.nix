{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
<<<<<<< HEAD
, jinja2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, packaging
, poetry-core
, pyparsing
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "pysigma";
<<<<<<< HEAD
  version = "0.10.5";
=======
  version = "0.9.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-iiE6XHj5632sBlivUHz7HiNRjNpEh+OMqcJ65o2km6I=";
  };

  pythonRelaxDeps = [
    "packaging"
  ];

=======
    hash = "sha256-N3BHIec1j4G5bVQu5KKTzmxr4fFjTWIZdmtp1pSfdSg=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

<<<<<<< HEAD
  propagatedBuildInputs = [
    jinja2
=======
  pythonRelaxDeps = [
    "packaging"
  ];

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    packaging
    pyparsing
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # require network connection
    "test_sigma_plugin_directory_default"
    "test_sigma_plugin_installation"
  ];

  pythonImportsCheck = [
    "sigma"
  ];

  meta = with lib; {
    description = "Library to parse and convert Sigma rules into queries";
    homepage = "https://github.com/SigmaHQ/pySigma";
    changelog = "https://github.com/SigmaHQ/pySigma/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
