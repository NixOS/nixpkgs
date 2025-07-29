{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  hatchling,
  hatch-requirements-txt,
  hatch-fancy-pypi-readme,

  # dependencies
  fsspec,
  httpx,
  huggingface-hub,
  packaging,
  typing-extensions,
  websockets,

  # tests
  gradio,
  pydub,
  pytest-asyncio,
  pytestCheckHook,
  rich,
  safehttpx,
  tomlkit,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "gradio-client";
  version = "1.11.0";
  pyproject = true;

  # no tests on pypi
  src = fetchFromGitHub {
    owner = "gradio-app";
    repo = "gradio";
    # not to be confused with @gradio/client@${version}
    tag = "gradio_client@${version}";
    sparseCheckout = [ "client/python" ];
    hash = "sha256-dj8hJPXUBbFG9awP3o0vgyPt+gcCgzKKEQTEHkrEimA=";
  };

  sourceRoot = "${src.name}/client/python";

  # upstream adds upper constraints because they can, not because the need to
  # https://github.com/gradio-app/gradio/pull/4885
  pythonRelaxDeps = [
    # only backward incompat is dropping py3.7 support
    "websockets"
  ];

  build-system = [
    hatchling
    hatch-requirements-txt
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    fsspec
    httpx
    huggingface-hub
    packaging
    typing-extensions
    websockets
  ];

  nativeCheckInputs = [
    gradio.sans-reverse-dependencies
    pydub
    pytest-asyncio
    pytestCheckHook
    rich
    safehttpx
    tomlkit
    writableTmpDirAsHomeHook
  ];
  # ensuring we don't propagate this intermediate build
  disallowedReferences = [ gradio.sans-reverse-dependencies ];

  # Add a pytest hook skipping tests that access network, marking them as "Expected fail" (xfail).
  preCheck = ''
    cat ${./conftest-skip-network-errors.py} >> test/conftest.py
  '';

  pytestFlags = [
    #"-x" "-Wignore" # uncomment for debugging help
  ];

  enabledTestPaths = [
    "test/"
  ];

  disabledTestMarks = [
    "flaky"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky: OSError: Cannot find empty port in range: 7860-7959
    "test_layout_components_in_output"
    "test_layout_and_state_components_in_output"
    "test_upstream_exceptions"
    "test_httpx_kwargs"
  ];

  pythonImportsCheck = [ "gradio_client" ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "gradio_client@(.*)"
    ];
  };

  meta = {
    homepage = "https://www.gradio.app/";
    changelog = "https://github.com/gradio-app/gradio/releases/tag/gradio_client@${version}";
    description = "Lightweight library to use any Gradio app as an API";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
