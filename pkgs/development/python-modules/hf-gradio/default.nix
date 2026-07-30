{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  gradio-client,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "hf-gradio";
  version = "0.4.1";
  pyproject = true;
  __structuredAttrs = true;

  # No tags on GitHub
  # https://github.com/gradio-app/hf-gradio/issues/2
  src = fetchPypi {
    pname = "hf_gradio";
    inherit (finalAttrs) version;
    hash = "sha256-oBfZQmGPDUlaWO5FYwR/oEvvYUwA4Mt4mpptBjPP+ns=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    gradio-client
    typer
  ];

  # The PyPI sdist ships no test suite.
  doCheck = false;

  pythonImportsCheck = [ "hf_gradio" ];

  meta = {
    description = "Extension of the Hugging Face CLI for interacting with Gradio Spaces and Apps";
    homepage = "https://pypi.org/project/hf-gradio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
