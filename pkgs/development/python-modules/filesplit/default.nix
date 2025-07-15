{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "filesplit";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ram-jayapalan";
    repo = "filesplit";
    tag = "v${version}";
    hash = "sha256-QttXCK/IalnOVilWQaE0FYhFglQ1nXDLUX3nOFI5Vrc=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "filesplit" ];

  meta = {
    description = "Split file into multiple chunks based on the given size";
    homepage = "https://github.com/ram-jayapalan/filesplit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
