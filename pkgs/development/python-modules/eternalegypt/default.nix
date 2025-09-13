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
  version = "0.0.18";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amelchio";
    repo = "eternalegypt";
    tag = "v${version}";
    hash = "sha256-dS4APZWOI8im1Ls1A5750FedTWBy3UpXvJmYpd1po94=";
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
