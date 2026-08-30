{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-auth,
  keyring,
  pluggy,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "keyrings-google-artifactregistry-auth";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "keyrings.google-artifactregistry-auth";
    inherit version;
    hash = "sha256-vWq7cnQNLf60pcA8OxBcb326FpyqKd7jlZaU8fAsd94=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    google-auth
    keyring
    pluggy
    requests
  ];

  pythonImportsCheck = [ "keyrings.gauth" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/GoogleCloudPlatform/artifact-registry-python-tools/blob/main/HISTORY.md";
    description = "Python package which allows you to configure keyring to interact with Python repositories stored in Artifact Registry";
    homepage = "https://github.com/GoogleCloudPlatform/artifact-registry-python-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
}
