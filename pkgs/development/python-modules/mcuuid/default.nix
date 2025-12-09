{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "mcuuid";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "clerie";
    repo = "mcuuid";
    tag = version;
    hash = "sha256-YwM7CdZVXpUXKXUzFL3AtoDhekLDIvZ/q8taLsHihNk=";
  };

  propagatedBuildInputs = [ requests ];

  # upstream code does not provide tests
  doCheck = false;

  pythonImportsCheck = [ "mcuuid" ];

  meta = with lib; {
    description = "Getting Minecraft player information from Mojang API";
    homepage = "https://github.com/clerie/mcuuid";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ clerie ];
  };
}
