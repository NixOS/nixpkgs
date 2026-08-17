{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  attrs,
  connectrpc,
  dockerfile-parse,
  h2,
  httpx,
  packaging,
  protobuf-py,
  pyqwest,
  python-dateutil,
  rich,
  typing-extensions,
  wcmatch,

  # tests
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "e2b";
  version = "2.39.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "e2b-dev";
    repo = "E2B";
    tag = "@e2b/python-sdk@${finalAttrs.version}";
    hash = "sha256-bB5MGXd3W66/hjodSqTAmlnr6iJjGx/5ET6nOofdkrI=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/python-sdk";

  # Upstream caps the build backend at uv_build<0.11.0; ours is newer.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.0,<0.11.0" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    attrs
    connectrpc
    dockerfile-parse
    h2
    httpx
    packaging
    protobuf-py
    pyqwest
    python-dateutil
    rich
    typing-extensions
    wcmatch
  ];

  pythonImportsCheck = [ "e2b" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  # Everything under tests/{async,sync,bugs} drives a real sandbox and needs an
  # API key. The rest runs offline against an in-process envd frame server.
  enabledTestPaths = [ "tests/test_*.py" ];

  # Import e2b from $out rather than the source tree.
  preCheck = ''
    rm -r e2b
  '';

  # The offline tests exercise the transport against an in-process server.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Cloud environments for AI agents";
    homepage = "https://github.com/e2b-dev/E2B/blob/main/packages/python-sdk";
    changelog = "https://github.com/e2b-dev/E2B/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      mishushakov
    ];
  };
})
