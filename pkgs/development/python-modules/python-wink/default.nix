{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-wink";
  version = "1.10.5";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-gHbuidZNBX/tP3RQ7Zf64t3ESQPmgyAtpcP7ju1S2OQ=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pywink" ];

  meta = {
    description = "Python implementation of the Wink API";
    homepage = "https://github.com/python-wink/python-wink";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
