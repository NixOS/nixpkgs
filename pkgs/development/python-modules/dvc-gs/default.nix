{ lib
, buildPythonPackage
, dvc-objects
, fetchPypi
, gcsfs
, pythonRelaxDepsHook
, setuptools-scm }:

buildPythonPackage rec {
  pname = "dvc-gs";
  version = "2.22.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UzYW2iU/GvLJd4q6ErcLQRoAehyFF3PrMTjb8PEtmNE=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

  propagatedBuildInputs = [ gcsfs dvc-objects ];

  # Network access is needed for tests
  doCheck = false;

  pythonCheckImports = [ "dvc_gs" ];

  meta = with lib; {
    description = "gs plugin for dvc";
    homepage = "https://pypi.org/project/dvc-gs/version";
    changelog = "https://github.com/iterative/dvc-gs/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
