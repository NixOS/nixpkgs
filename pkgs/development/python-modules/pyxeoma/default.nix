{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyxeoma";
  version = "1.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xqPthVAlZi35s1ri0crD+kF3WnYSZVgEvecnaoyrjRw=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project doesn't have any tests
  doCheck = false;
  pythonImportsCheck = [ "pyxeoma" ];

  meta = with lib; {
    description = "Python wrapper for Xeoma web server API";
    homepage = "https://github.com/jeradM/pyxeoma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
