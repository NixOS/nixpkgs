{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  tkinter,
}:

buildPythonPackage rec {
  pname = "guppy3";
  version = "3.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zhuyifei1999";
    repo = "guppy3";
    tag = "v${version}";
    hash = "sha256-hgJcy4DRfZL50dCcRv2a6GJPDabsUMfDtq7HCXXYYz8=";
  };

  build-system = [ setuptools ];

  dependencies = [ tkinter ];

  # Tests are starting a Tkinter GUI
  doCheck = false;

  pythonImportsCheck = [ "guppy" ];

  meta = with lib; {
    description = "Python Programming Environment & Heap analysis toolset";
    homepage = "https://zhuyifei1999.github.io/guppy3/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
