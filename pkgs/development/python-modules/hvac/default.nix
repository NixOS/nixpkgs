{ lib
, buildPythonPackage
, fetchPypi
, pyhcl
, requests
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hvac";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tIvNoRpKsKe2xHIyx7p8h/2jGK4tSnZigAxGWnh0KJQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyhcl
    requests
  ];

  # Requires running a Vault server
  doCheck = false;

  pythonImportsCheck = [
    "hvac"
  ];

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    changelog = "https://github.com/hvac/hvac/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
