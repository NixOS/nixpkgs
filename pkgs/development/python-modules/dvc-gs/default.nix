{
  lib,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  gcsfs,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dvc-gs";
  version = "3.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "dvc_gs";
    inherit version;
    hash = "sha256-c5aTwNglCjkHS6Fsfc51K7Wn/5NEQtYIH/z9ftkxO5o=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  build-system = [ setuptools-scm ];

  dependencies = [
    gcsfs
    dvc-objects
  ];

  # Network access is needed for tests
  doCheck = false;

  # Circular dependency
  # pythonImportsCheck = [
  #   "dvc_gs"
  # ];

  meta = with lib; {
    description = "gs plugin for dvc";
    homepage = "https://pypi.org/project/dvc-gs/version";
    changelog = "https://github.com/iterative/dvc-gs/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
