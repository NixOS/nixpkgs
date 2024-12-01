{
  lib,
  aiohttp,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "eternalegypt";
  version = "0.0.16";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amelchio";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ubKepd3yBaoYrIUe5WCt1zd4CjvU7SeftOR+2cBaEf0=";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "eternalegypt" ];

  meta = with lib; {
    description = "Python API for Netgear LTE modems";
    homepage = "https://github.com/amelchio/eternalegypt";
    changelog = "https://github.com/amelchio/eternalegypt/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
