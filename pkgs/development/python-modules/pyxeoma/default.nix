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
    sha256 = "c6a3ed855025662df9b35ae2d1cac3fa41775a7612655804bde7276a8cab8d1c";
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
