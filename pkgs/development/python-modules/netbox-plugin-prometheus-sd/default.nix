{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  netaddr,
  netbox,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "netbox-plugin-prometheus-sd";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "FlxPeters";
    repo = "netbox-plugin-prometheus-sd";
    tag = "v${version}";
    hash = "sha256-UtvSkqs2PN3uxCB78hJjh0lZ1WbZGjDpwlKyeAGpiEM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
    substituteInPlace netbox_prometheus_sd/__init__.py \
      --replace-fail "from extras.plugins import PluginConfig" "from netbox.plugins import PluginConfig"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    django
    netaddr
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_prometheus_sd" ];

  meta = with lib; {
    description = "Netbox plugin to provide Netbox entires to Prometheus HTTP service discovery";
    homepage = "https://github.com/FlxPeters/netbox-plugin-prometheus-sd";
    changelog = "https://github.com/FlxPeters/netbox-plugin-prometheus-sd/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio ];
  };
}
