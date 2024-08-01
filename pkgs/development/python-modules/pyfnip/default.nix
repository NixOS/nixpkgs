{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pyfnip";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q52rb0kshgbligxjqrwz0v7kgqjbv6jahdb66ndxy93mfr0ig3a";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyfnip" ];

  meta = with lib; {
    description = "Python client to get fido account data";
    homepage = "https://github.com/juhaniemi/pyfnip";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
