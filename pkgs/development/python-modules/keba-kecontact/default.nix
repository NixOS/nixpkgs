{
  lib,
  asyncio-dgram,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  ifaddr,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "keba-kecontact";
  version = "4.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dannerph";
    repo = "keba-kecontact";
    tag = version;
    hash = "sha256-Ir/7lP8TDyOTwIMXKv2d9HYuT9onxrQskdkNhQYaOvU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    asyncio-dgram
    ifaddr
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "keba_kecontact" ];

  meta = {
    description = "Python library for controlling KEBA charging stations";
    homepage = "https://github.com/dannerph/keba-kecontact";
    changelog = "https://github.com/dannerph/keba-kecontact/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
