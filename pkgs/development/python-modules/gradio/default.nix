{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook

# pyproject
, hatchling
, hatch-requirements-txt
, hatch-fancy-pypi-readme

# runtime
, setuptools
, aiofiles
, altair
, fastapi
, ffmpy
, gradio-client
, httpx
, huggingface-hub
, importlib-resources
, jinja2
, markupsafe
, matplotlib
, numpy
, orjson
, packaging
, pandas
, pillow
, pydantic
, python-multipart
, pydub
, pyyaml
, requests
, semantic-version
, typing-extensions
, uvicorn
, websockets

# check
, pytestCheckHook
, boto3
, ffmpeg
, ipython
, pytest-asyncio
, respx
, scikit-image
, torch
, tqdm
, transformers
, vega-datasets
}:

buildPythonPackage rec {
  pname = "gradio";
  version = "3.44.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  # We use the Pypi release, as it provides prebuilt webui assets,
  # and has more frequent releases compared to github tags
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3mXs9PwlzUo89VosBWtnsOzDQf/T22Yv7s5j6OLLp3M=";
  };

  # fix packaging.ParserSyntaxError, which can't handle comments
  postPatch = ''
    sed -ie "s/ #.*$//g" requirements*.txt
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
    hatchling
    hatch-requirements-txt
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    setuptools # needed for 'pkg_resources'
    aiofiles
    altair
    fastapi
    ffmpy
    gradio-client
    httpx
    huggingface-hub
    importlib-resources
    jinja2
    markupsafe
    matplotlib
    numpy
    orjson
    packaging
    pandas
    pillow
    pydantic
    python-multipart
    pydub
    pyyaml
    requests
    semantic-version
    typing-extensions
    uvicorn
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
    boto3
    ffmpeg
    ipython
    pytest-asyncio
    respx
    scikit-image
    # shap is needed as well, but breaks too often
    torch
    tqdm
    transformers
    vega-datasets
  ];

  # Add a pytest hook skipping tests that access network, marking them as "Expected fail" (xfail).
  # We additionally xfail FileNotFoundError, since the gradio devs often fail to upload test assets to pypi.
  preCheck = ''
    export HOME=$TMPDIR
    cat ${./conftest-skip-network-errors.py} >> test/conftest.py
  '';

  disabledTests = [
    # Actually broken
    "test_mount_gradio_app"

    # requires network, it caught our xfail exception
    "test_error_analytics_successful"

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
  pytestFlagsArray = [
    "-x"  # abort on first failure
    #"-m" "not flaky" # doesn't work, even when advertised
    #"-W" "ignore" # uncomment for debugging help
  ];

  # check the binary works outside the build env
  doInstallCheck = true;
  postInstallCheck = ''
    env --ignore-environment $out/bin/gradio environment >/dev/null
  '';

  pythonImportsCheck = [ "gradio" ];

  meta = with lib; {
    homepage = "https://www.gradio.app/";
    description = "Python library for easily interacting with trained machine learning models";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
