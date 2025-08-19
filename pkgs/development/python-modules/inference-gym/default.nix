{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "inference-gym";
  version = "0.0.5";
  format = "wheel";

  src = fetchPypi {
    inherit format version;
    pname = "inference_gym";
    dist = "py3";
    python = "py3";
    hash = "sha256-E3lNgCZIObPBkl0PWACUG19XOiCOh1+N/sUFHQyA/wE=";
  };

  pythonImportsCheck = [ "inference_gym" ];

  # The package does not ship any test.
  doCheck = false;

  meta = {
    description = "Place to exercise inference methods to help make them faster, leaner and more robust";
    homepage = "https://github.com/tensorflow/probability/tree/main/spinoffs/inference_gym";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
