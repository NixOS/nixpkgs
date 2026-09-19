{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pykefcontrol";
  version = "0.9";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "N0ciple";
    repo = "pykefcontrol";
    tag = version;
    hash = "sha256-V/uYzzUv/PslfZ/zSSAK4j6kI9lLQOXBN1AG0rjRrpg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.8"' 'version = "0.9"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    requests
  ];

  # Upstream does not ship tests.
  doCheck = false;

  pythonImportsCheck = [ "pykefcontrol" ];

  meta = {
    description = "Python library for controlling KEF LS50 Wireless II, LSX II, and LS60 speakers";
    homepage = "https://github.com/N0ciple/pykefcontrol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imalison ];
    platforms = lib.platforms.unix;
  };
}
