{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "boltons";
  version = "21.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mahmoud";
    repo = "boltons";
    rev = version;
    hash = "sha256-8HO7X2PQEbQIQsCa2cMHQI3rlofVT22GYrWNXY34MLk=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  patches = lib.optionals (pythonAtLeast "3.10") [
    # pprint has no attribute _safe_repr, https://github.com/mahmoud/boltons/issues/294
    (fetchpatch {
      name = "fix-pprint-attribute.patch";
      url = "https://github.com/mahmoud/boltons/commit/270e974975984f662f998c8f6eb0ebebd964de82.patch";
      sha256 = "sha256-pZLfr6SRCw2aLwZeYaX7bzfJeZC4cFUILEmnVsKR6zc=";
    })
  ];

  # Tests bind to localhost
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "boltons"
  ];

  meta = with lib; {
    homepage = "https://github.com/mahmoud/boltons";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
  };
}
