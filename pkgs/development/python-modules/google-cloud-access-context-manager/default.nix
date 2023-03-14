{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, pythonOlder
, protobuf
}:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
  version = "0.1.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+L5Rre6LHpSlc+yzdQpMLSvURLHd412apDes5zwzdgc=";
  };

  propagatedBuildInputs = [
    google-api-core
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  # No tests in repo
  doCheck = false;

  pythonImportsCheck = [
    "google.identity.accesscontextmanager"
  ];

  meta = with lib; {
    description = "Protobufs for Google Access Context Manager";
    homepage = "https://github.com/googleapis/python-access-context-manager";
    changelog = "https://github.com/googleapis/python-access-context-manager/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
  };
}
