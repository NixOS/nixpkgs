{
  lib,
  buildPythonPackage,
  fetchPypi,
  # deps
  cryptography
}:

buildPythonPackage rec {
  pname = "ntlmlib";
  version = "0.72";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-azZQJ+w82vCUIaZ5pbKzl6i0H4rd6NzYi4DmlajS6cI=";
  };

  patches = [
    ./remove-ordereddict.patch
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  meta = {
    description = "A robust, fast and efficient ‘first-class’ Python Library for NTLM authentication, signing and encryption";
    license = lib.licenses.asl20;
    homepage = "https://github.com/ianclegg/ntlmlib/";
    maintainers = with lib.maintainers; [ purefns ];
  };
}
