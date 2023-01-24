{ lib
, buildPythonPackage
, cachecontrol
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
, schema-salad
}:

buildPythonPackage rec {
  pname = "cwl-utils";
  version = "0.21";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-y1zuYaxoE0XUk8UpCLsg4ty0sn+5Uu4ztRnUoJezO/o=";
  };

  propagatedBuildInputs = [
    cachecontrol
    cwl-upgrader
    packaging
    rdflib
    requests
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
  ];

  meta = with lib; {
    description = "Utilities for CWL";
    homepage = "https://github.com/common-workflow-language/cwl-utils";
    changelog = "https://github.com/common-workflow-language/cwl-utils/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
