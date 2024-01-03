{ lib
, requests
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rachiopy";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rfverbruggen";
    repo = pname;
    rev = version;
    sha256 = "sha256-PsdEXNy8vUxba/C00ARhLTQU9gMlChy9XdU20r+Maus=";
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
