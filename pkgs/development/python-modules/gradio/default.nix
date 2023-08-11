{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
, writeText

# pyproject
, hatchling
, hatch-requirements-txt
, hatch-fancy-pypi-readme

# runtime
, setuptools
, aiofiles
, aiohttp
, altair
, fastapi
, ffmpy
, markdown-it-py
, mdit-py-plugins
, markupsafe
, matplotlib
, numpy
, orjson
, pandas
, pillow
, pycryptodome
, python-multipart
, pydub
, pyyaml
, requests
, uvicorn
, jinja2
, fsspec
, httpx
, pydantic
, websockets
, typing-extensions

# check
, pytestCheckHook
, pytest-asyncio
, mlflow
, huggingface-hub
, transformers
, wandb
, respx
, scikit-image
, ipython
, ffmpeg
, vega_datasets
, boto3
}:

buildPythonPackage rec {
  pname = "gradio";
  version = "3.20.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  # We use the Pypi release, as it provides prebuilt webui assets,
  # and has more frequent releases compared to github tags
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oG97GwehyBWjWXzDqyfj+x2mAfM6OQhYKdA3j0Rv8Vs=";
  };

  pythonRelaxDeps = [
    "mdit-py-plugins"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    hatchling
    hatch-requirements-txt
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    setuptools # needs pkg_resources
    aiofiles
    aiohttp
    altair
    fastapi
    ffmpy
    markdown-it-py
    mdit-py-plugins
    markupsafe
    matplotlib
    numpy
    orjson
    pandas
    pillow
    pycryptodome
    python-multipart
    pydub
    pyyaml
    requests
    uvicorn
    jinja2
    fsspec
    httpx
    pydantic
    websockets
    typing-extensions
  ] ++ markdown-it-py.optional-dependencies.linkify;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    mlflow
    #comet-ml # FIXME: enable once packaged
    huggingface-hub
    transformers
    wandb
    respx
    scikit-image
    ipython
    ffmpeg
    vega_datasets
    boto3
    # shap is needed as well, but breaks too often
  ];

  # Add a pytest hook skipping tests that access network, marking them as "Expected fail" (xfail).
  # We additionally xfail FileNotFoundError, since the gradio devs often fail to upload test assets to pypi.
  preCheck = let
  in ''
    export HOME=$TMPDIR
    cat ${./conftest-skip-network-errors.py} >> test/conftest.py
  '';

  disabledTests = [
    # Actually broken
    "test_mount_gradio_app"

    # FIXME: enable once comet-ml is packaged
    "test_inline_display"
    "test_integration_comet"

    # Flaky, tries to pin dependency behaviour. Sensitive to dep versions
    # These error only affect downstream use of the check dependencies.
    "test_no_color"
    "test_in_interface_as_output"
    "test_should_warn_url_not_having_version"

    # Flaky, unknown reason
    "test_in_interface"

    # shap is too often broken in nixpkgs
    "test_shapley_text"
  ];
  disabledTestPaths = [
    # makes pytest freeze 50% of the time
    "test/test_interfaces.py"
  ];
  #pytestFlagsArray = [ "-x" "-W" "ignore" ]; # uncomment for debugging help

  # check the binary works outside the build env
  doInstallCheck = true;
  postInstallCheck = ''
    env --ignore-environment $out/bin/gradio --help >/dev/null
  '';

  pythonImportsCheck = [ "gradio" ];

  meta = with lib; {
    homepage = "https://www.gradio.app/";
    description = "Python library for easily interacting with trained machine learning models";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
