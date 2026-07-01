{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  buildPythonPackage,
  setuptools,
  websockets,
  pytest-asyncio_0,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kyuupichan";
    repo = "aiorpcX";
    tag = version;
    hash = "sha256-mFg9mWrlnfXiQpgZ1rxvUy9TBfwy41XEKmsCf2nvxGo=";
  };

  patches = [
    # fix asyncio.get_event_loop() usage in tests for python 3.14
    (fetchpatch2 {
      url = "https://github.com/kyuupichan/aiorpcX/commit/b8ce32889c45c98b44c4e247ec0b0ae206e9ee91.patch?full_index=1";
      hash = "sha256-EIxGR3M5dfX4ZyPFftVdPFcsg9WwYBG/h31edu6Te8o=";
      includes = [ "tests/test_util.py" ];
    })
    # make test_misc async so it runs inside pytest-asyncio's loop on python 3.14
    (fetchpatch2 {
      url = "https://github.com/kyuupichan/aiorpcX/commit/25043621700672ee375d20b78804118acac43b1b.patch?full_index=1";
      hash = "sha256-q4tqbcPQj6SU06Xn/4ns1NriLLx8zmUOGJo11ucA6Dk=";
    })
  ];

  build-system = [ setuptools ];

  optional-dependencies.ws = [ websockets ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # network access
    "test_create_connection_resolve_good"
  ];

  pythonImportsCheck = [ "aiorpcx" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Transport, protocol and framing-independent async RPC client and server implementation";
    homepage = "https://github.com/kyuupichan/aiorpcX";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
