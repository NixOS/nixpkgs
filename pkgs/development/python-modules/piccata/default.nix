{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "piccata";
  version = "2.0.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = pname;
    rev = version;
    sha256 = "0pn842jcf2czjks5dphivgp1s7wiifqiv93s0a89h0wxafd6pbsr";
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
