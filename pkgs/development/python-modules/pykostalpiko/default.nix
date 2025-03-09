{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pykostalpiko";
  version = "1.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Florian7843";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kmzFsOgmMb8bOkulg7G6vXEPdb0xizh7u5LjnHfEWWQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    click
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykostalpiko" ];

  meta = with lib; {
    description = "Library and CLI-tool to fetch the data from a Kostal Piko inverter";
    homepage = "https://github.com/Florian7843/pykostalpiko";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
