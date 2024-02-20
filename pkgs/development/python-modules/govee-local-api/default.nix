{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "govee-local-api";
  version = "1.4.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Galorhallen";
    repo = "govee-local-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-J4SG4n6LIZ/G6pEXAzliV7uTWzqsH7rtFe3Y7BJ2dWE=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "govee_local_api"
  ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/Galorhallen/govee-local-api";
    changelog = "https://github.com/Galorhallen/govee-local-api/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
