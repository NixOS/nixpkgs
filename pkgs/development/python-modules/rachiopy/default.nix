{ lib
, requests
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rachiopy";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "rfverbruggen";
    repo = pname;
    rev = version;
    sha256 = "1d5v9qc7ymzns3ivc5fzwxnxz9sjkhklh57cw05va95mpk5kdskc";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rachiopy" ];

  meta = with lib; {
    description = "Python client for Rachio Irrigation controller";
    homepage = "https://github.com/rfverbruggen/rachiopy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
