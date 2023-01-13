{ lib
, fetchFromGitHub
, buildPythonPackage
, ply
, decorator
, pytestCheckHook
, oslotest
}:

buildPythonPackage rec {
  pname = "bc-jsonpath-ng";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = "jsonpath-ng";
    rev = "refs/tags/${version}";
    hash = "sha256-sS7Y46sMX+imemNdoZUkVPp1llZTQrOkNjMdCxW0wiI=";
  };

  propagatedBuildInputs = [
    decorator
    ply
  ];

  checkInputs = [
    oslotest
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Implementation of JSONPath for Python";
    homepage = "https://github.com/bridgecrewio/jsonpath-ng";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
