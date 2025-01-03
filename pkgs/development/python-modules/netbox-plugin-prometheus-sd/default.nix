{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  netbox,
}:

buildPythonPackage rec {
  pname = "netbox-plugin-prometheus-sd";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FlxPeters";
    repo = "netbox-plugin-prometheus-sd";
    rev = "v${version}";
    hash = "sha256-UtvSkqs2PN3uxCB78hJjh0lZ1WbZGjDpwlKyeAGpiEM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    netbox
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_prometheus_sd" ];

  meta = with lib; {
    description = "Netbox plugin to provide Netbox entires to Prometheus HTTP service discovery";
    homepage = "https://pypi.org/project/netbox-plugin-prometheus-sd/";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio ];
  };
}
