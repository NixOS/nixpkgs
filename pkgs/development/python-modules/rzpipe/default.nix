{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rzpipe";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KKqPFMGgsmiYZ0tXTIhhvhLDfm/iV8JcYeVc4akezYc=";
  };

  build-system = [ setuptools ];

  # No native rz_core library
  doCheck = false;

  pythonImportsCheck = [ "rzpipe" ];

  meta = with lib; {
    description = "Python interface for rizin";
    homepage = "https://rizin.re";
    changelog = "https://github.com/rizinorg/rizin/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
