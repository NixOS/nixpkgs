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
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b1qg1rgTi1hdRlbR/gG12HYWMQyASEuQnMhMLLjwZP0=";
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
