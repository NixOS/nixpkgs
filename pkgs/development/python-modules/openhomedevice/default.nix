{
  lib,
  aioresponses,
  async-upnp-client,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openhomedevice";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bazwilliams";
    repo = "openhomedevice";
    tag = version;
    hash = "sha256-u05aciRFCnqMJRClUMApAPDLpXOKn4wUTLgvR7BVZTA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    async-upnp-client
    lxml
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
  ];

  pythonImportsCheck = [ "openhomedevice" ];

  enabledTestPaths = [ "tests/*.py" ];

  meta = {
    description = "Python module to access Linn Ds and Openhome devices";
    homepage = "https://github.com/bazwilliams/openhomedevice";
    changelog = "https://github.com/bazwilliams/openhomedevice/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
