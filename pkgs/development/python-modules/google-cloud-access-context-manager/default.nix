{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  protobuf,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-access-context-manager";
<<<<<<< HEAD
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_access_context_manager";
    inherit version;
    hash = "sha256-86o1ySJbeq74Xs2s7cwVd3ib6NRYt6QbatI7UEeG5fk=";
=======
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_access_context_manager";
    inherit version;
    hash = "sha256-wt6A+6EZDkZ50zYmOE0Z4EpWujtNRh7VIeiSCa9jogk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  # No tests in repo
  doCheck = false;

  pythonImportsCheck = [ "google.identity.accesscontextmanager" ];

<<<<<<< HEAD
  meta = {
    description = "Protobufs for Google Access Context Manager";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-access-context-manager";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-access-context-manager-v${version}/packages/google-cloud-access-context-manager/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ austinbutler ];
=======
  meta = with lib; {
    description = "Protobufs for Google Access Context Manager";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-access-context-manager";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-access-context-manager-v${version}/packages/google-cloud-access-context-manager/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
