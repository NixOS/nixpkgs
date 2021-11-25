{ lib, buildPythonPackage, fetchPypi, google-api-core }:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "249a1c1a858bb182b73749784457baacfcab8e7c13da5f3421109d5b8dace5b8";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "google-api-core[grpc] >= 1.26.0, < 2.0.0dev" "google-api-core[grpc] >= 1.26.0, < 2.0.1"
  '';

  propagatedBuildInputs = [ google-api-core ];

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
