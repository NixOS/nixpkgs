{ lib, buildPythonPackage, fetchPypi, pythonOlder, google-api-core }:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "011hbbjqjqk6fskb180hfhhsddz3i2a9gz34sf4wy1j2s4my9xy0";
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
