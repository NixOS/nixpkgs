{ lib
, aiohttp
, attrs
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "eternalegypt";
  version = "0.0.13";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amelchio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wi2cqd81irqm873npkqg3mvdrb57idqdsp8qw8h0s7lk0kil1wi";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
