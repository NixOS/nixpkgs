{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  conda-package-streaming,
}:
buildPythonPackage rec {
  pname = "conda-package-handling";
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda-package-handling";
    rev = version;
    hash = "sha256-WeGfmT6lLwcwhheLBPMFcVMudY+zPsvTuXuOsiEAorQ=";
  };

  pyproject = true;
  build-system = [ setuptools ];
  dependencies = [ conda-package-streaming ];

  pythonImportsCheck = [ "conda_package_handling" ];

  meta = {
    description = "Create and extract conda packages of various formats";
    homepage = "https://github.com/conda/conda-package-handling";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
