{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.12";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OHTuAh8JsKnK9sDkXZbx/P9ElrQRSCGBk83wuhL8qEg=";
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
