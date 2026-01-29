{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  django,
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
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devon-mar";
    repo = "netbox-kea";
    tag = "v${version}";
    hash = "sha256-uSVJoWzGHTbmkekjsLC59rko/5uo3ju/LYC/dV3xAQE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    django
    netaddr
  ];

  nativeCheckInputs = [
    pytestCheckHook
    netbox
    types-requests
    mypy
    pytest-playwright
    pynetbox
    django-stubs
    ruff
  ];

  # requires running NetBox instance on localhost:8000 for API tests
  doCheck = false;

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
