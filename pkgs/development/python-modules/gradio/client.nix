{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,

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
  requests,
  rich,
  safehttpx,
  tomlkit,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gradio-client";
  version = "2.2.0";
  pyproject = true;

  # no tests on pypi
  src = fetchFromGitHub {
    owner = "gradio-app";
    repo = "gradio";
    # not to be confused with @gradio/client@${version}
    # tag = "gradio_client@${finalAttrs.version}";
    # TODO: switch back to a tag next release, if they tag it.
    rev = "8b03393a51e1e03fb04cb0a41b9a5dc3266a58aa"; # 2.2.0
    sparseCheckout = [
      "client/python"
      "gradio/media_assets"
    ];
    hash = "sha256-LkTZwPyHe1w8D5unEMW7dBGKNHxM7gWJ7I+4HwiexKk=";
  };

  sourceRoot = "${finalAttrs.src.name}/client/python";

  # Because we set sourceRoot above, the folders "client/python"
  # don't exist, as far as this is concerned.
  postPatch = ''
    substituteInPlace test/conftest.py \
      --replace-fail 'from client.python.test import media_data' 'import media_data'
  '';

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
    requests
    rich
    safehttpx
    tomlkit
    writableTmpDirAsHomeHook
  ];
  # ensuring we don't propagate this intermediate build
  disallowedReferences = [ gradio.sans-reverse-dependencies ];

  postInstall = ''
    mkdir -p $out/lib/gradio
    cp -r ../../gradio/media_assets $out/lib/gradio
  '';

  # Add a pytest hook skipping tests that access network, marking them as "Expected fail" (xfail).
  preCheck = ''
    cat ${./conftest-skip-network-errors.py} >> test/conftest.py
  '';

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

  passthru.updateScript = gitUpdater {
    rev-prefix = "gradio_client@";
    ignoredVersions = ".*-(beta|dev).*";
  };

  meta = {
    description = "Lightweight library to use any Gradio app as an API";
    homepage = "https://www.gradio.app/";
    downloadPage = "https://github.com/gradio-app/gradio/tree/main/client/python";
    # changelog = "https://github.com/gradio-app/gradio/releases/tag/${finalAttrs.src.tag}"; TODO: uncomment if the tag exists
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
  };
})
