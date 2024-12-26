{
  lib,
  asyncio-dgram,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  ifaddr,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "keba-kecontact";
  version = "4.0.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "dannerph";
    repo = "keba-kecontact";
    rev = "refs/tags/${version}";
    hash = "sha256-HzfoWijsrtDNElqyxWB7f07OTMIoS/fEjmdX59G+Hw0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    asyncio-dgram
    ifaddr
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "keba_kecontact" ];

  meta = with lib; {
    description = "Python library for controlling KEBA charging stations";
    homepage = "https://github.com/dannerph/keba-kecontact";
    changelog = "https://github.com/dannerph/keba-kecontact/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
