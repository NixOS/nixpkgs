{ lib
, adlfs
, azure-identity
, buildPythonPackage
, fetchPypi
, knack
, pythonRelaxDepsHook
, setuptools-scm }:

buildPythonPackage rec {
  pname = "dvc-azure";
  version = "2.21.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0PB+2lPAV2yy2hivDDz0PXmi8WqoSlUZadyfKPp9o1g=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    adlfs azure-identity knack
  ];

  # Network access is needed for tests
  doCheck = false;

  pythonCheckImports = [ "dvc_azure" ];

  meta = with lib; {
    description = "azure plugin for dvc";
    homepage = "https://pypi.org/project/dvc-azure/${version}";
    changelog = "https://github.com/iterative/dvc-azure/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
