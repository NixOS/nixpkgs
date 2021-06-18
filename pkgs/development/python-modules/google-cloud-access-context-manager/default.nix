{ lib, buildPythonPackage, fetchPypi, pythonOlder, google-api-core }:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5453e64ca885c302f54c7a630de15e1e0b2c5ef21107ea69bd96fd694d723d5e";
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
