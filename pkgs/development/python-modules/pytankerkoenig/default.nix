{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pytankerkoenig";
  version = "0.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "021fg1a4n3527fz86zxfbsi0jrk0dnai1y92q6hwh5za68lrs710";
  };

  # Tests require an API key and network access
  doCheck = false;
  pythonImportsCheck = [ "pytankerkoenig" ];

  meta = with lib; {
    description = "Python module to get fuel data from tankerkoenig.de";
    homepage = "https://github.com/ultrara1n/pytankerkoenig";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
