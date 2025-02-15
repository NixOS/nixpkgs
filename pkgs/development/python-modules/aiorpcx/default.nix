{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  websockets,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kyuupichan";
    repo = "aiorpcX";
    tag = "0.24"; # TODO: https://github.com/kyuupichan/aiorpcX/issues/52
    hash = "sha256-0c4AqKDWAmAFR1t42VE54kgbupe4ljajCR/TB5fZfME=";
  };

  build-system = [ setuptools ];

  optional-dependencies.ws = [ websockets ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
