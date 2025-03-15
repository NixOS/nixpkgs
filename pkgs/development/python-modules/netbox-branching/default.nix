{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  netaddr,
  netbox,
  setuptools,
}:

buildPythonPackage rec {
  pname = "netbox-branching";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netboxlabs";
    repo = "netbox-branching";
    tag = "v${version}";
    hash = "sha256-mEW51u22wHU94OOebbV4c3L1kaTOGDR5Dtpdha2tql0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    django
    netaddr
    netbox
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  disabledTests = [
    "tests.legacy.test_auth.AuthClientServerTests.test_basic_auth_invalid_password"
  ];

  pythonImportsCheck = [ "netbox_branching" ];

  meta = {
    description = "Official NetBox Labs plugin that implements git-like branching functionality for NetBox";
    homepage = "https://github.com/netboxlabs/netbox-branching";
    changelog = "https://github.com/netboxlabs/netbox-branching/releases/tag/${src.tag}";
    license = lib.licenses.polyFormShield;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
    broken = lib.versionOlder netbox.version "4.1.8";
  };
}
