{
  lib,
  buildPythonPackage,
  requests,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "rjpl";
  version = "0.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GLNIpZuM3yuCnPyjBa8KjdaL5cFK8InluuY+LTCrimc=";
  };

  propagatedBuildInputs = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "rjpl" ];

  meta = {
    description = "Library for interacting with the Rejseplanen API";
    homepage = "https://github.com/tomatpasser/python-rejseplanen";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
