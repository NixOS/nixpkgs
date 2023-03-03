{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "piccata";
  version = "2.0.2";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-Vuhwt+esTkvyEIRVYaRGvNMTAXVWBBv/6lpaxN5RrBA=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # No communication possible in the sandbox
    "test_client_server_communication"
  ];

  pythonImportsCheck = [
    "piccata"
  ];

  meta = with lib; {
    description = "Simple CoAP (RFC7252) toolkit";
    homepage = "https://github.com/NordicSemiconductor/piccata";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
