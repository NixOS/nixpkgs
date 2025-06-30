{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyhomepilot";
  version = "0.0.3";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nico0302";
    repo = "pyhomepilot";
    rev = "v${version}";
    sha256 = "00gmqx8cwsd15iccnlr8ypgqrdg6nw9ha518cfk7pyp8vhw1ziwy";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyhomepilot" ];

  meta = with lib; {
    description = "Python module to communicate with the Rademacher HomePilot API";
    homepage = "https://github.com/nico0302/pyhomepilot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
