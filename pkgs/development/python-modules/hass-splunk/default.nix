{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "hass-splunk";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bre77";
    repo = "hass_splunk";
    tag = "v${version}";
    hash = "sha256-PvTmzMYlmZYjs9CnOPbjFneiZPgfDTlVqRtfl53uY78=";
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
