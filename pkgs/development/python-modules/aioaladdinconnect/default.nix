{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioaladdinconnect";
  version = "0.1.20";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkmer";
    repo = "AIOAladdinConnect";
    rev = version;
    hash = "sha256-JHGAJx1Hb/NKWZ+y1ACmVUiesYj1VVHnYCcP+XZGADs=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "AIOAladdinConnect"
  ];

  meta = with lib; {
    description = "Library for controlling Genie garage doors connected to Aladdin Connect devices";
    homepage = "https://github.com/mkmer/AIOAladdinConnect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
