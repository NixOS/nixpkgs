{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "boltons";
  version = "24.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mahmoud";
    repo = "boltons";
    rev = "refs/tags/${version}";
    hash = "sha256-Ie5CPT2u/2/hAIhDzXT6CPzJwmbgt3B6q3oxqKYb27o=";
  };

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
