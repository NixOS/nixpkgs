{ lib
, buildPythonPackage
, fetchFromGitHub
, pyhcl
, requests
, six
}:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.11.2";

  src = fetchFromGitHub {
     owner = "ianunruh";
     repo = "hvac";
     rev = "v0.11.2";
     sha256 = "0cd7am9q73b5r7lhqsx0i0flvpykxkk4c5zmxpdix8ljxbj4qn8p";
  };

  propagatedBuildInputs = [
    pyhcl
    requests
    six
  ];

  # Requires running a Vault server
  doCheck = false;

  pythonImportsCheck = [ "hvac" ];

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
