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
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5UMKKX+4GCNm98S8kQsasQTY5cwi9hGhm84FFl3/7NQ=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
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
