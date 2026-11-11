{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "mbddns";
  version = "0.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "thinkl33t";
    repo = "mb-ddns";
    rev = version;
    hash = "sha256-R1ovq6biSGeMrsKwa6B4YVF7/08WKNI//WCHifOdv48=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mbddns" ];

  meta = {
    description = "Mythic Beasts Dynamic DNS updater";
    homepage = "https://github.com/thinkl33t/mb-ddns";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
