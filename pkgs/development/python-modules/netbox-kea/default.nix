{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  netaddr,
  pytestCheckHook,
  netbox,
  types-requests,
  mypy,
  pytest-playwright,
  pynetbox,
  django-stubs,
  ruff,
}:
buildPythonPackage rec {
  pname = "netbox-kea";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devon-mar";
    repo = "netbox-kea";
    tag = "v${version}";
    hash = "sha256-/Lt3QbboG7tI43xxUmT04nZ9UGz/mQveEZU6UUNnbUU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    netaddr
  ];

  nativeCheckInputs = [
    pytestCheckHook
    netbox
    types-requests
    mypy
    pytest-playwright # TODO RELAX
    pynetbox # TODO RELAX
    django-stubs
    ruff
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_kea" ];

  meta = {
    description = "Manage Kea DHCP leases in NetBox";
    homepage = "https://github.com/devon-mar/netbox-kea";
    changelog = "https://github.com/devon-mar/netbox-kea/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
