{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pykostalpiko";
  version = "1.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Florian7843";
    repo = "pykostalpiko";
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

  meta = {
    description = "Library and CLI-tool to fetch the data from a Kostal Piko inverter";
    homepage = "https://github.com/Florian7843/pykostalpiko";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
