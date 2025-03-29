{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "boltons";
  version = "25.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mahmoud";
    repo = "boltons";
    tag = version;
    hash = "sha256-kBOU17/jRRAGb4MGawY0PY31OJf5arVz+J7xGBoMBkg=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests bind to localhost
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "boltons" ];

  meta = with lib; {
    description = "Constructs, recipes, and snippets extending the Python standard library";
    longDescription = ''
      Boltons is a set of over 200 BSD-licensed, pure-Python utilities
      in the same spirit as - and yet conspicuously missing from - the
      standard library, including:

      - Atomic file saving, bolted on with fileutils
      - A highly-optimized OrderedMultiDict, in dictutils
      - Two types of PriorityQueue, in queueutils
      - Chunked and windowed iteration, in iterutils
      - Recursive data structure iteration and merging, with iterutils.remap
      - Exponential backoff functionality, including jitter, through
      iterutils.backoff
      - A full-featured TracebackInfo type, for representing stack
      traces, in tbutils
    '';
    homepage = "https://github.com/mahmoud/boltons";
    changelog = "https://github.com/mahmoud/boltons/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
  };
}
