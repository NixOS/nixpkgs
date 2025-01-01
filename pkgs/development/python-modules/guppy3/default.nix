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
    repo = pname;
    tag = "v${version}";
    hash = "sha256-hgJcy4DRfZL50dCcRv2a6GJPDabsUMfDtq7HCXXYYz8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ tkinter ];

  # Tests are starting a Tkinter GUI
  doCheck = false;
  pythonImportsCheck = [ "guppy" ];

  meta = with lib; {
    description = "Python Programming Environment & Heap analysis toolset";
    homepage = "https://zhuyifei1999.github.io/guppy3/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
