{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pyombi";
  version = "0.1.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/bKYgjh2gebDBBExymjD2iVVx3lHojJw8rSALVira/o=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyombi" ];

  meta = with lib; {
    description = "Python module to retrieve information from Ombi";
    homepage = "https://github.com/larssont/pyombi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
