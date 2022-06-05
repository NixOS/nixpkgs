{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nvwb5q8ZzN8Uz69H4KH+XLInHlJtm84WFmEmJ3M14so=";
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
