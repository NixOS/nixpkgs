{ lib, buildPythonPackage, fetchPypi, pythonOlder, google-api-core }:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VFPmTKiFwwL1THpjDeFeHgssXvIRB+ppvZb9aU1yPV4=";
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
