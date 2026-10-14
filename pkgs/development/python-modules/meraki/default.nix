{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
}:

buildPythonPackage (finalAttrs: {
  pname = "meraki";
  version = "4.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meraki";
    repo = "dashboard-api-python";
    tag = finalAttrs.version;
    hash = "sha256-bEzSrsZm0uNH0JMes+aNrsixCP3KhxcynOcYxLvI9HA=";
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
