{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pyombi";
  version = "0.1.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ykbmdc2v05ly9q358j7g73ma9fsqdlclc8i0k1yd0bn7219icpx";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyombi" ];

  meta = {
    description = "Python module to retrieve information from Ombi";
    homepage = "https://github.com/larssont/pyombi";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
