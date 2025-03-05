{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  requests,
  standard-telnetlib,
}:

buildPythonPackage rec {
  pname = "pyfnip";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q52rb0kshgbligxjqrwz0v7kgqjbv6jahdb66ndxy93mfr0ig3a";
  };

  propagatedBuildInputs = [
    requests
  ] ++ lib.optionals (pythonAtLeast "3.13") [ standard-telnetlib ];

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
