{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
, writeShellScriptBin
, gradio

# pyproject
, hatchling
, hatch-requirements-txt
, hatch-fancy-pypi-readme

# runtime
, setuptools
, aiofiles
, altair
, diffusers
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
, semantic-version
, typing-extensions
, uvicorn
, typer
, tomlkit

# oauth
, authlib
, itsdangerous

# check
, pytestCheckHook
, boto3
, gradio-pdf
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
  version = "4.22.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  # We use the Pypi release, since it provides prebuilt webui assets,
  # and upstream has stopped tagging releases since 3.41.0
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nhrT509xB3+R+HF6TF5AQGnfufT6iNmzjxZgcVL7fBo=";
  };

  # fix packaging.ParserSyntaxError, which can't handle comments
  postPatch = ''
    sed -ie "s/ #.*$//g" requirements*.txt

    # they bundle deps?
    rm -rf venv/
  '';

  pythonRelaxDeps = [
    "tomlkit"
  ];

  pythonRemoveDeps = [
    # our package is presented as a binary, not a python lib - and
    # this isn't a real runtime dependency
    "ruff"
  ];

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
    diffusers
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
    semantic-version
    typing-extensions
    uvicorn
    typer
    tomlkit
  ] ++ typer.passthru.optional-dependencies.all;

  passthru.optional-dependencies.oauth = [
    authlib
    itsdangerous
  ];

  nativeCheckInputs = [
    pytestCheckHook
    boto3
    gradio-pdf
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

    # mock calls to `shutil.which(...)`
    (writeShellScriptBin "npm" "false")
  ]
  ++ passthru.optional-dependencies.oauth
  ++ pydantic.passthru.optional-dependencies.email;

  # Add a pytest hook skipping tests that access network, marking them as "Expected fail" (xfail).
  # We additionally xfail FileNotFoundError, since the gradio devs often fail to upload test assets to pypi.
  preCheck = ''
    export HOME=$TMPDIR
    cat ${./conftest-skip-network-errors.py} >> test/conftest.py
  '' + lib.optionalString stdenv.isDarwin ''
    # OSError: [Errno 24] Too many open files
    ulimit -n 4096
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

    # fails without network
    "test_download_if_url_correct_parse"

    # tests if pip and other tools are installed
    "test_get_executable_path"
  ];
  disabledTestPaths = [
    # 100% touches network
    "test/test_networking.py"
    # makes pytest freeze 50% of the time
    "test/test_interfaces.py"
  ];
  pytestFlagsArray = [
    "-x"  # abort on first failure
    "-m 'not flaky'"
    #"-W" "ignore" # uncomment for debugging help
  ];

  # check the binary works outside the build env
  doInstallCheck = true;
  postInstallCheck = ''
    env --ignore-environment $out/bin/gradio environment >/dev/null
  '';

  pythonImportsCheck = [ "gradio" ];

  # Cyclic dependencies are fun!
  # This is gradio without gradio-client and gradio-pdf
  passthru.sans-reverse-dependencies = (gradio.override (old: {
      gradio-client = null;
      gradio-pdf = null;
    })).overridePythonAttrs (old: {
      pname = old.pname + "-sans-reverse-dependencies";
      pythonRemoveDeps = (old.pythonRemoveDeps or []) ++ [ "gradio-client" ];
      doInstallCheck = false;
      doCheck = false;
      pythonImportsCheck = null;
      dontCheckRuntimeDeps = true;
    });

  meta = with lib; {
    homepage = "https://www.gradio.app/";
    description = "Python library for easily interacting with trained machine learning models";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
