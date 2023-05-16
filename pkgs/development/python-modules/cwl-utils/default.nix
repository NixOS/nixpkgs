{ lib
, buildPythonPackage
<<<<<<< HEAD
=======
, cachecontrol
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cwl-upgrader
, cwlformat
, fetchFromGitHub
, packaging
, pytest-mock
, pytest-xdist
, pytestCheckHook
, pythonOlder
, rdflib
, requests
<<<<<<< HEAD
, ruamel-yaml
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, schema-salad
}:

buildPythonPackage rec {
  pname = "cwl-utils";
<<<<<<< HEAD
  version = "0.29";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "0.24";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-XxfeBikJcRcUCIVDAmPTtcrrgvZYrRKpjs5bmMokeeI=";
  };

  propagatedBuildInputs = [
=======
    hash = "sha256-g8HnY5/UDmujijXStNRwKBGMZ3soUHKPIlpJdIQaAlE=";
  };

  propagatedBuildInputs = [
    cachecontrol
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cwl-upgrader
    packaging
    rdflib
    requests
<<<<<<< HEAD
    ruamel-yaml
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    schema-salad
  ];

  nativeCheckInputs = [
    cwlformat
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cwl_utils"
  ];

  disabledTests = [
    # Don't run tests which require Node.js
    "test_context_multiple_regex"
    "test_value_from_two_concatenated_expressions"
    "test_graph_split"
    "test_caches_js_processes"
    "test_load_document_with_remote_uri"
<<<<<<< HEAD
    # Don't run tests which require network access
    "test_remote_packing"
    "test_remote_packing_github_soft_links"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Utilities for CWL";
    homepage = "https://github.com/common-workflow-language/cwl-utils";
    changelog = "https://github.com/common-workflow-language/cwl-utils/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
