{
  lib,
  buildPythonPackage,
  dvc,
  fetchFromGitHub,
  pydrive2,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dvc-gdrive";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-gdrive";
    tag = version;
    hash = "sha256-oqHSMmwfR24ydJlpXGI3cCxIlF0BwNdgje5zKa0c7FA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dvc
    pydrive2
  ];

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [ "dvc_gdrive" ];

  meta = with lib; {
    description = "Google Drive plugin for DVC";
    homepage = "https://github.com/iterative/dvc-gdrive";
    changelog = "https://github.com/iterative/dvc-gdrive/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
