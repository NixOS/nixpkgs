{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyhomeworks";
  version = "0.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "Eqbm8274B2hBuF+mREe8lqGhpzZExPJ29jzvwB5RNR8=";
  };

  # Project has no real tests
  doCheck = false;

  pythonImportsCheck = [ "pyhomeworks" ];

  meta = with lib; {
    description = "Python interface to Lutron Homeworks Series 4/8";
    homepage = "https://github.com/dubnom/pyhomeworks";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
