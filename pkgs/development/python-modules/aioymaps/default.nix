{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioymaps";
  version = "1.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pW8FoMdA8XdQZmLRwk5SBBgFhYhgEMJPA9+b+8aicuE=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioymaps" ];

  meta = with lib; {
    description = "Python package fetch data from Yandex maps";
    homepage = "https://github.com/devbis/aioymaps";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
