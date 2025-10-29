{
  lib,
  buildPythonPackage,
  requests,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "rjpl";
  version = "0.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GLNIpZuM3yuCnPyjBa8KjdaL5cFK8InluuY+LTCrimc=";
  };

  propagatedBuildInputs = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "rjpl" ];

  meta = with lib; {
    description = "Library for interacting with the Rejseplanen API";
    homepage = "https://github.com/tomatpasser/python-rejseplanen";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
