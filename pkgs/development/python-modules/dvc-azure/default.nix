{
  lib,
  adlfs,
  azure-identity,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  knack,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dvc-azure";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UsvHDVQUtQIZs9sKFvaK0l2rp24/Igrr5OSbPGSYriA=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    adlfs
    azure-identity
    dvc-objects
    knack
  ];

  # Network access is needed for tests
  doCheck = false;

  # Circular dependency
  # pythonImportsCheck = [
  #   "dvc_azure"
  # ];

  meta = with lib; {
    description = "Azure plugin for dvc";
    homepage = "https://pypi.org/project/dvc-azure/${version}";
    changelog = "https://github.com/iterative/dvc-azure/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
