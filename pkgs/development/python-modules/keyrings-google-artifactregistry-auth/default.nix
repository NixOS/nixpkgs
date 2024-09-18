{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-auth,
  keyring,
  pluggy,
  pythonOlder,
  requests,
  setuptools-scm,
  toml,
}:

buildPythonPackage rec {
  pname = "keyrings.google-artifactregistry-auth";
  version = "1.1.2";

  disabled = pythonOlder "3.6";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vWq7cnQNLf60pcA8OxBcb326FpyqKd7jlZaU8fAsd94=";
  };

  buildInputs = [
    setuptools-scm
    toml
  ];

  propagatedBuildInputs = [
    google-auth
    keyring
    pluggy
    requests
  ];

  pythonImportsCheck = [ "keyrings.gauth" ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/GoogleCloudPlatform/artifact-registry-python-tools/blob/main/HISTORY.md";
    description = "Python package which allows you to configure keyring to interact with Python repositories stored in Artifact Registry";
    homepage = "https://pypi.org/project/keyrings.google-artifactregistry-auth";
    license = licenses.asl20;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
