{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
  napalm,
  django,
}:
buildPythonPackage rec {
  pname = "netbox-napalm-plugin";
  version = "0.3.3";
  pyproject = true;

  disabled = python.pythonVersion != netbox.python.pythonVersion;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-napalm-plugin";
    tag = "v${version}";
    hash = "sha256-qo16Bwq2a9AbO80qnQo0WtJ7HbrqqGChMJaqYYD5Aqg=";
  };

  build-system = [ setuptools ];

  dependencies = [ napalm ];

  nativeCheckInputs = [
    netbox
    django
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'napalm<5.0' 'napalm'
  '';

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_napalm_plugin" ];

  meta = {
    description = "Netbox plugin for Napalm integration";
    homepage = "https://github.com/netbox-community/netbox-napalm-plugin";
    changelog = "https://github.com/netbox-community/netbox-napalm-plugin/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
