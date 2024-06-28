{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, netbox
}:

buildPythonPackage rec {
  pname = "netbox-plugin-prometheus-sd";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "netbox_plugin_prometheus_sd";
    inherit version;
    hash = "sha256-vKYtfTR5BVm31ibeJwdwumVO0SoXRF07gdFS+zehc9Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
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
