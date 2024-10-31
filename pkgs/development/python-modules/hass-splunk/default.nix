{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "hass-splunk";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bre77";
    repo = "hass_splunk";
    rev = "refs/tags/v${version}";
    hash = "sha256-bgF6gHAA57MiWdmpwilGa+l05/ETKdpyi2naVagkRlc=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "hass_splunk" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Async single threaded connector to Splunk HEC using an asyncio session";
    homepage = "https://github.com/Bre77/hass_splunk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
