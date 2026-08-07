{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
}:

buildPythonPackage rec {
  pname = "meraki";
  version = "4.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meraki";
    repo = "dashboard-api-python";
    tag = version;
    hash = "sha256-X4ndUNSnn7Dx2le9Ryfio1/x8J3NjCGcjVHg0JmVoMk=";
  };

  build-system = [ hatchling ];

  dependencies = [ httpx ];

  # All tests require an API key
  doCheck = false;

  pythonImportsCheck = [ "meraki" ];

  meta = {
    description = "Cisco Meraki cloud-managed platform dashboard API python library";
    homepage = "https://github.com/meraki/dashboard-api-python";
    changelog = "https://github.com/meraki/dashboard-api-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
  };
}
