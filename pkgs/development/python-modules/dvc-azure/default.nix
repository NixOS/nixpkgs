{ lib
, adlfs
, azure-identity
, buildPythonPackage
, dvc-objects
, fetchPypi
, knack
, pythonRelaxDepsHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dvc-azure";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TB7yY5b2AWBFt8+AnxyKyP6hoXi6cdHVjtffapRVfHc=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [
    "dvc"
  ];

  nativeBuildInputs = [
    setuptools-scm
    pythonRelaxDepsHook
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
