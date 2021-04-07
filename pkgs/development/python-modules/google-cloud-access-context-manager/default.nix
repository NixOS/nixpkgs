{ lib, buildPythonPackage, fetchPypi, pythonOlder, google-api-core }:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qy7wv1xn7g3x5z0vvv0pwmxhin4hw2m9fs9iklnghy00vg37v0b";
  };

  propagatedBuildInputs = [ google-api-core ];

  # No tests in repo
  doCheck = false;

  pythonImportsCheck = [
    "google.identity.accesscontextmanager"
  ];

  meta = with lib; {
    description = "Protobufs for Google Access Context Manager.";
    homepage = "https://github.com/googleapis/python-access-context-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
  };
}
