{ lib
, adlfs
, azure-identity
, buildPythonPackage
, dvc-objects
, fetchPypi
, knack
, pythonRelaxDepsHook
, setuptools-scm }:

buildPythonPackage rec {
  pname = "dvc-azure";
  version = "2.22.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aGPh77HLeUcddGtmFcLd9bc+WaYAFUprtpFkw3h5iSc=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    adlfs azure-identity dvc-objects knack
  ];

  # Network access is needed for tests
  doCheck = false;

  pythonImportsCheck = [ "dvc_azure" ];

  meta = with lib; {
    description = "azure plugin for dvc";
    homepage = "https://pypi.org/project/dvc-azure/${version}";
    changelog = "https://github.com/iterative/dvc-azure/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
