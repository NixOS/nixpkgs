{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  hatch-fancy-pypi-readme,
  hatchling,

  # dependencies
  anyio,
  distro,
  docstring-parser,
  httpx2,
  jiter,
  pydantic,
  sniffio,
  typing-extensions,

  # optional dependencies
  google-auth,
  boto3,
  botocore,
  aiohttp,
  httpx-aiohttp,

  # tests
  dirty-equals,
  http-snapshot,
  inline-snapshot,
  nest-asyncio,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  respx,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "anthropic";
  version = "1.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q3g+bqgMJuDtR9TETrDXWp/SyyeAdPWnnJxbL4FuFdM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"hatchling==1.26.3"' '"hatchling>=1.26.3"'
  '';

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    anyio
    distro
    docstring-parser
    httpx2
    jiter
    pydantic
    sniffio
    typing-extensions
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
      httpx-aiohttp
    ];
    bedrock = [
      boto3
      botocore
    ];
    vertex = [ google-auth ] ++ google-auth.optional-dependencies.requests;
  };

  nativeCheckInputs = [
    dirty-equals
    http-snapshot
    inline-snapshot
    nest-asyncio
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    respx
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "anthropic" ];

  disabledTests = [
    # Test require network access
    "test_copy_build_request"
    # Tests try to launch bash and fail
    "test_bash_session_persistence"
    "test_bash_timeout"
    "test_bash_sentinel_not_spoofable"
    "test_bash_stdin_redirect"
    "test_bash_session_closed_property"
    "test_bash_outer_cancel_closes_subprocess_no_stale_state"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Hangs
    # https://github.com/anthropics/anthropic-sdk-python/issues/1008
    "test_get_platform"

    # Fail in the sandbox:
    #   AssertionError: Regex pattern did not match.
    #     Expected regex: "outside the session's working directory and its other permitted directories"
    #     Actual message: "path '/nix/var/nix/builds/nix-53257-3010075771/pytest-of-_nixbld1/pytest-0/popen-gw2/test_resolve_path_symlink_out_0/mount/leak': permission denied"
    "test_resolve_path_absolute_inside_workdir"
    "test_resolve_path_symlink_out_of_allowed_root_is_rejected"
  ];

  disabledTestPaths = [
    # Test require network access
    "tests/api_resources"
    "tests/lib/test_bedrock.py"
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  meta = {
    description = "Anthropic's safety-first language model APIs";
    homepage = "https://github.com/anthropics/anthropic-sdk-python";
    changelog = "https://github.com/anthropics/anthropic-sdk-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.natsukium
      lib.maintainers.sarahec
    ];
  };
})
