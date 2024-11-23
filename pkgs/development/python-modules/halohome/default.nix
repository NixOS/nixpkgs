{
  lib,
  aiohttp,
  bleak,
  buildPythonPackage,
  csrmesh,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "halohome";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nayaverdier";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-oGwg9frE5LaUxmXjwaD0ZtY6D8D7f8tH0knZDaSm+XI=";
  };

  propagatedBuildInputs = [
    aiohttp
    bleak
    csrmesh
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "halohome" ];

  meta = with lib; {
    description = "Python library to control Eaton HALO Home Smart Lights";
    homepage = "https://github.com/nayaverdier/halohome";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
