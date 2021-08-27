{ lib, buildPythonPackage, fetchPypi, google-api-core }:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02adf212c8d280298ffe03a0c91743618693ec394b42cbb85b4a29f8d9544afa";
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
