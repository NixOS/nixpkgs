{
  lib,
  android-backup,
  appdirs,
  attrs,
  buildPythonPackage,
  click,
  construct,
  croniter,
  cryptography,
  defusedxml,
  fetchPypi,
  fetchpatch,
  micloud,
  netifaces,
  poetry-core,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pytz,
  pyyaml,
  tqdm,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "python-miio";
  version = "0.5.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BJw1Gg3FO2R6WWKjkrpxDN4fTMTug5AIj0SNq1gEbBY=";
  };

  pythonRelaxDeps = [ "defusedxml" ];

  build-system = [ poetry-core ];

  patches = [
    (fetchpatch {
      # Fix pytest 7.2 compat
      url = "https://github.com/rytilahti/python-miio/commit/67d9d771d04d51f5bd97f361ca1c15ae4a18c274.patch";
      hash = "sha256-Os9vCSKyieCqHs63oX6gcLrtv1N7hbX5WvEurelEp8w=";
    })
    (fetchpatch {
      # Python 3.13 compat
      url = "https://github.com/rytilahti/python-miio/commit/0aa4df3ab1e47d564c8312016fbcfb3a9fc06c6c.patch";
      hash = "sha256-Zydv3xqCliA/oAnjNmqh0vDrlZFPcTAIyW6vIZzijZY=";
    })
  ];

  dependencies = [
    android-backup
    appdirs
    attrs
    click
    construct
    croniter
    cryptography
    defusedxml
    micloud
    netifaces
    pytz
    pyyaml
    tqdm
    zeroconf
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "miio" ];

  meta = {
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = lib.licenses.gpl3Only;
  };
}
