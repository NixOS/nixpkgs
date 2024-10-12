{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pythonOlder,
  # pyproject
  hatchling,
  hatch-requirements-txt,
  hatch-fancy-pypi-readme,
  # runtime
  setuptools,
  fsspec,
  httpx,
  huggingface-hub,
  packaging,
  typing-extensions,
  websockets,
  # checkInputs
  pytestCheckHook,
  pytest-asyncio,
  pydub,
  rich,
  tomlkit,
  gradio,
}:

buildPythonPackage rec {
  pname = "gradio-client";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # no tests on pypi
  src = fetchFromGitHub {
    owner = "gradio-app";
    repo = "gradio";
    # not to be confused with @gradio/client@${version}
    rev = "refs/tags/gradio_client@${version}";
    sparseCheckout = [ "client/python" ];
    hash = "sha256-UZQWguUN3l0cj2wb2f7A61RTLy9nPYcIEwHIo+F1kR0=";
  };
  prePatch = ''
    cd client/python
  '';

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
    setuptools # needed for 'pkg_resources'
    fsspec
    httpx
    huggingface-hub
    packaging
    typing-extensions
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pydub
    rich
    tomlkit
    gradio.sans-reverse-dependencies
  ];
  # ensuring we don't propagate this intermediate build
  disallowedReferences = [ gradio.sans-reverse-dependencies ];

  # Add a pytest hook skipping tests that access network, marking them as "Expected fail" (xfail).
  preCheck = ''
    export HOME=$TMPDIR
    cat ${./conftest-skip-network-errors.py} >> test/conftest.py
  '';

  pytestFlagsArray = [
    "test/"
    "-m 'not flaky'"
    #"-x" "-W" "ignore" # uncomment for debugging help
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
    extraArgs = [ "--version-regex" "gradio_client@(.*)" ];
  };

  meta = with lib; {
    homepage = "https://www.gradio.app/";
    description = "Lightweight library to use any Gradio app as an API";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
