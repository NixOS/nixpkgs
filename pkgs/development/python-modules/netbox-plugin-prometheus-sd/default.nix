{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  django,
  netaddr,
  netbox,
  psycopg,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-plugin-prometheus-sd";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FlxPeters";
    repo = "netbox-plugin-prometheus-sd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2SVfWkw6/AkDihWp9chU8rTqLiSn9ax4uLaK1xydfGM=";
  };

  postPatch = ''
    substituteInPlace netbox_prometheus_sd/__init__.py \
      --replace-fail "from extras.plugins import PluginConfig" "from netbox.plugins import PluginConfig"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    django
    netaddr
    psycopg # not specified in pyproject.toml, but required at import time
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_prometheus_sd" ];

  meta = {
    description = "Netbox plugin to provide Netbox entires to Prometheus HTTP service discovery";
    homepage = "https://github.com/FlxPeters/netbox-plugin-prometheus-sd";
    changelog = "https://github.com/FlxPeters/netbox-plugin-prometheus-sd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xanderio ];
  };
})
