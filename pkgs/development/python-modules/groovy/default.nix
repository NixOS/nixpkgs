{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  gradio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "groovy";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JcHcCbP51+KSRYqnYsa+uW6gNwcb9ekX/IH7eNIjEIM=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [ "groovy" ];

  nativeCheckInputs = [
    gradio
    pytestCheckHook
  ];

  # Attempts to load a cert file
  # FileNotFoundError: [Errno 2] No such file or directory
  doCheck = false;

  meta = {
    description = "Small Python library created to help developers protect their applications from Server Side Request Forgery (SSRF) attacks";
    homepage = "https://pypi.org/project/groovy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
