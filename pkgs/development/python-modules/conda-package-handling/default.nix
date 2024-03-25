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
  pyproject = true;
  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda-package-handling";
    rev = version;
    hash = "sha256-WeGfmT6lLwcwhheLBPMFcVMudY+zPsvTuXuOsiEAorQ=";
  };
  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ conda-package-streaming ];

  meta = {
    description = "Create and extract conda packages of various formats";
    homepage = "https://github.com/conda/conda-package-handling";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
