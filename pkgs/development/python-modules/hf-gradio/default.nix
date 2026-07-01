{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  gradio-client,
  typer,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hf-gradio";
  version = "0.4.1";
  pyproject = true;
  __structuredAttrs = true;

  # No tags on GitHub
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

  pythonImportsCheck = [ "hf_gradio" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "An extension of the Hugging Face CLI for interacting with Gradio Spaces and Apps";
    homepage = "https://pypi.org/project/hf-gradio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
