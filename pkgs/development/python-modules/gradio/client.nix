{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
# pyproject
, hatchling
, hatch-requirements-txt
, hatch-fancy-pypi-readme
# runtime
, setuptools
, fsspec
, httpx
, huggingface-hub
, packaging
, requests
, typing-extensions
, websockets
# checkInputs
, pytestCheckHook
, pytest-asyncio
, pydub
, gradio
}:

let

  # Cyclic dependencies are fun!
  # This is gradio without gradio-client, only needed for checkPhase
  gradio' = (gradio.override (old: {
    gradio-client = null;
  })).overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pythonRelaxDepsHook ];
    pythonRemoveDeps = (old.pythonRemoveDeps or []) ++ [ "gradio_client" ];
    doInstallCheck = false;
    doCheck = false;
    pythonImportsCheck = null;
  });

in

buildPythonPackage rec {
  pname = "gradio_client";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  # no tests on pypi
  src = fetchFromGitHub {
    owner = "gradio-app";
    repo = "gradio";
    #rev = "refs/tags/v${gradio.version}";
    rev = "ba4c6d9e65138c97062d1757d2a588c4fc449daa"; # v3.43.1 is not tagged...
    sparseCheckout = [ "client/python" ];
    hash = "sha256-savka4opyZKSWPeBqc2LZqvwVXLYIZz5dS1OWJSwvHo=";
  };
  prePatch = ''
    cd client/python
  '';

  nativeBuildInputs = [
    hatchling
    hatch-requirements-txt
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    setuptools # needed for 'pkg_resources'
    fsspec
    httpx
    huggingface-hub
    packaging
    requests
    typing-extensions
    websockets
  ];

  nativeCheckInputs =[
    pytestCheckHook
    pytest-asyncio
    pydub
    gradio'
  ];
  disallowedReferences = [
    gradio' # ensuring we don't propagate this intermediate build
  ];

  # Add a pytest hook skipping tests that access network, marking them as "Expected fail" (xfail).
  preCheck = ''
    export HOME=$TMPDIR
    cat ${./conftest-skip-network-errors.py} >> test/conftest.py
  '';

  pytestFlagsArray = [
    "test/"
    #"-m" "not flaky" # doesn't work, even when advertised
    #"-x" "-W" "ignore" # uncomment for debugging help
  ];

  pythonImportsCheck = [ "gradio_client" ];

  meta = with lib; {
    homepage = "https://www.gradio.app/";
    description = "Lightweight library to use any Gradio app as an API";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
