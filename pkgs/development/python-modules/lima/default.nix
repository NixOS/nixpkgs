{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lima";
  version = "0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OxBBmzZGM+PtpSw5ixIMVH/Z1YVOTO/ZvPecPAoAEmM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lima" ];

<<<<<<< HEAD
  meta = {
    description = "Lightweight Marshalling of Python Objects";
    homepage = "https://github.com/b6d/lima";
    changelog = "https://github.com/b6d/lima/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
=======
  meta = with lib; {
    description = "Lightweight Marshalling of Python Objects";
    homepage = "https://github.com/b6d/lima";
    changelog = "https://github.com/b6d/lima/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
