{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "piccata";
  version = "2.0.3";
  format = "setuptools";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "piccata";
    tag = version;
    hash = "sha256-wdfujQ8QYHZGFsnI0fQRSEI6sOCsDXj2FX0ZII5zmtA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # No communication possible in the sandbox
    "test_client_server_communication"
  ];

  pythonImportsCheck = [ "piccata" ];

  meta = with lib; {
    description = "Simple CoAP (RFC7252) toolkit";
    homepage = "https://github.com/NordicSemiconductor/piccata";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
