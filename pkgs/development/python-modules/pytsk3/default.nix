{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "pytsk3";
  version = "20231007";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uPE5ytLj+sv/fp1AYjwIdrHLRQU/EVnDZQEGwcK6T/g=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.8";

  pythonImportsCheck = [ "pytsk3" ];

  meta = with lib; {
    changelog = "https://github.com/py4n6/pytsk/releases/tag/${version}";
    description = "Python bindings for the sleuthkit (http://www.sleuthkit.org/)";
    downloadPage = "https://github.com/py4n6/pytsk/releases";
    homepage = "https://github.com/py4n6/pytsk";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
