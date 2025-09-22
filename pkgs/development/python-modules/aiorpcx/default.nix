{
  lib,
  fetchFromGitHub,
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

  build-system = [ setuptools ];

  optional-dependencies.ws = [ websockets ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # network access
    "test_create_connection_resolve_good"
  ];

  pythonImportsCheck = [ "aiorpcx" ];

  meta = with lib; {
    description = "Transport, protocol and framing-independent async RPC client and server implementation";
    homepage = "https://github.com/kyuupichan/aiorpcX";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
