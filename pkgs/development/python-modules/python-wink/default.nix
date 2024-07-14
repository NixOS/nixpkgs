{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "python-wink";
  version = "1.10.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gHbuidZNBX/tP3RQ7Zf64t3ESQPmgyAtpcP7ju1S2OQ=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pywink" ];

  meta = with lib; {
    description = "Python implementation of the Wink API";
    homepage = "https://github.com/python-wink/python-wink";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
