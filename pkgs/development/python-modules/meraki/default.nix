{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
}:

buildPythonPackage (finalAttrs: {
  pname = "meraki";
  version = "4.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meraki";
    repo = "dashboard-api-python";
    tag = finalAttrs.version;
    hash = "sha256-L8J92qy1h0oDArQdg4TLAYMjp6rT9Zi//fk+Ddsdeqg=";
  };

  build-system = [ hatchling ];

  dependencies = [ httpx ];

  # All tests require an API key
  doCheck = false;

  pythonImportsCheck = [ "meraki" ];

  meta = {
    description = "Cisco Meraki cloud-managed platform dashboard API python library";
    homepage = "https://github.com/meraki/dashboard-api-python";
    changelog = "https://github.com/meraki/dashboard-api-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
  };
})
