{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbkdf2,
  requests,
  cashaddress,
  pyperclip,
}:

buildPythonPackage rec {
  pname = "pycryptotools";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oXvBit2Z8o6QXC12ob1jX9A0wsev6Kfbtwz/fBmnRls=";
  };

  propagatedBuildInputs = [
    pbkdf2
    requests
    cashaddress
    pyperclip
  ];

  pythonImportsCheck = [ "pycryptotools" ];

  meta = with lib; {
    changelog = "https://pypi.org/project/pycryptotools/#history";
    description = "Pycryptotools, Python library for Crypto coins signatures and transactions";
    homepage = "https://pypi.org/project/pycryptotools/";
    license = licenses.mit;
    maintainers = with maintainers; [ eymeric ];
  };
}
