{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,
  uv-dynamic-versioning,

  # dependencies
  h11,
  truststore,

  # optional dependencies
  h2,
  socksio,
  trio,
  anyio,

  # tests
  pytestCheckHook,
  pytest-httpbin,
  pytest-trio,

  # reverse deps
  httpx2,
}:

buildPythonPackage (finalAttrs: {
  pname = "httpcore2";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "httpx2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T5As4cdZRHkWszzaDZX8G8Z35TkaBsB/oy92FtOhuBY=";
  };

  postPatch = ''
    pushd src/httpcore2
  '';

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
    uv-dynamic-versioning
  ];

  dependencies = [
    h11
    truststore
  ];

  optional-dependencies = {
    asyncio = [ anyio ];
    http2 = [ h2 ];
    socks = [ socksio ];
    trio = [ trio ];
  };

  pythonImportsCheck = [
    "httpcore2"
  ];

  preCheck = ''
    popd
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-httpbin
    pytest-trio
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [ "tests/httpcore2" ];

  passthru.tests = {
    inherit httpx2;
  };

  __darwinAllowLocalNetworking = true;
  __structuredAttrs = true;

  meta = {
    description = "A next generation HTTP client for Python";
    homepage = "https://github.com/pydantic/httpx2";
    changelog = "https://github.com/pydantic/httpx2/blob/${finalAttrs.src.tag}/src/httpcore2/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
