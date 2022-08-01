{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AnWAJyvLU4vurVv9uJvi2fkl0Sk1nCK5iNxSplxflHs=";
  };

  propagatedBuildInputs = [
    google-api-core
  ];

  # No tests in repo
  doCheck = false;

  pythonImportsCheck = [
    "google.identity.accesscontextmanager"
  ];

  meta = with lib; {
    description = "Protobufs for Google Access Context Manager";
    homepage = "https://github.com/googleapis/python-access-context-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
  };
}
