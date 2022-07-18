{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, writeText

# pyproject
, hatchling
, hatch-requirements-txt
, hatch-fancy-pypi-readme

# runtime
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
, shap
, ipython
, ffmpeg
, vega_datasets
, boto3
}:

let
  # breaks way too frquently
  shapWorks = (builtins.tryEval shap.outPath).success;
in

buildPythonPackage rec {
  pname = "gradio";
  version = "3.20.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  # We use the Pypi release, as it provides prebuild webui assets,
  # and its releases are also more frequent than github tags
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oG97GwehyBWjWXzDqyfj+x2mAfM6OQhYKdA3j0Rv8Vs=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace \
        "mdit-py-plugins<=0.3.3" \
        "mdit-py-plugins"
  '';

  propagatedBuildInputs = [
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

  nativeBuildInputs = [
    hatchling
    hatch-requirements-txt
    hatch-fancy-pypi-readme
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    mlflow
    #cometml # FIXME: enable once comet-ml is packaged
    huggingface-hub
    transformers
    wandb
    respx
    scikit-image
    ipython
    ffmpeg
    vega_datasets
    boto3
   ] ++ lib.optional shapWorks shap;

  # Add pytest hook skipping tests that access network, marking them as "Expected fail" (xfail)
  # We additionally xfail FileNotFoundError, as gradio often fail to upload test files to pypi.
  preCheck = let
    conftestSkipNetworkErrors = writeText "conftest-network-xfail.py" ''
      from _pytest.runner import pytest_runtest_makereport as orig_pytest_runtest_makereport
      import urllib, urllib3, httpx, requests, websockets

      class NixNetworkAccessDeniedError(BaseException): pass
      def deny_network_access(*a, **kw):
        raise NixNetworkAccessDeniedError

      def iterate_exc_chain(exc: Exception):
        yield exc
        if getattr(exc, "__context__", None) is not None:
          yield from iterate_exc_chain(exc.__context__)
        if getattr(exc, "__cause__", None) is not None:
          yield from iterate_exc_chain(exc.__cause__)

      httpx.Request = \
      httpx.AsyncClient.get = \
      httpx.AsyncClient.head = \
      requests.head = \
      requests.get = \
      requests.post = \
      urllib.request.urlopen = \
      urllib.request.Request = \
      urllib3.connection.HTTPSConnection._new_conn = \
      websockets.connect = \
        deny_network_access

      def pytest_runtest_makereport(item, call):
        tr = orig_pytest_runtest_makereport(item, call)
        if call.excinfo is not None:
          for exc in iterate_exc_chain(call.excinfo.value):
            if isinstance(exc, NixNetworkAccessDeniedError):
              tr.outcome, tr.wasxfail = 'skipped', "reason: Requires network access."
            if isinstance(exc, FileNotFoundError):
              tr.outcome, tr.wasxfail = 'skipped', "reason: Pypi dist bad."
        return tr
    '';
  in ''
    export HOME=$TMPDIR
    cat ${conftestSkipNetworkErrors} >> test/conftest.py
  '';

  disabledTests = [
    # Actually broken
    "test_mount_gradio_app"

    # FIXME: enable once comet-ml is packaged
    "test_inline_display"
    "test_integration_comet"

    # Flaky (very sensitive to dep version)
    "test_in_interface_as_output"
    "test_should_warn_url_not_having_version"
  ]
  ++ lib.optionals (!shapWorks) [
    "test_shapley_text"
  ];
  disabledTestPaths = [
    # makes pytest freeze 50% of the time
    "test/test_interfaces.py"
  ];
  #pytestFlagsArray = [ "-x" "-W" "ignore" ]; # uncomment for debugging help

  pythonImportsCheck = [ "gradio" ];

  meta = with lib; {
    homepage = "https://www.gradio.app/";
    description = "Python library for easily interacting with trained machine learning models";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
