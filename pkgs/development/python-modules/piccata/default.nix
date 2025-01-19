{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "piccata";
  version = "2.0.2";
  format = "setuptools";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = pname;
    tag = version;
    hash = "sha256-Vuhwt+esTkvyEIRVYaRGvNMTAXVWBBv/6lpaxN5RrBA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # No communication possible in the sandbox
    "test_client_server_communication"
  ];

  pythonImportsCheck = [ "piccata" ];

  meta = {
    description = "Simple CoAP (RFC7252) toolkit";
    homepage = "https://github.com/NordicSemiconductor/piccata";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
