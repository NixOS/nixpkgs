{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "littleutils";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5srjpCA+Uw1RyWZ+0xD/47GUjyh249aWBbPeS32WkW8=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "littleutils" ];

  meta = with lib; {
    description = "Small collection of Python utility functions";
    homepage = "https://github.com/alexmojaki/littleutils";
    changelog = "https://github.com/alexmojaki/littleutils/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
