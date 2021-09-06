{ lib, buildPythonApplication, fetchPypi
, pbr, openstack-oslo_config, openstack-oslo_context, openstack-oslo_i18n, openstack-oslo_utils, openstack-oslo_serialization, openstack-debtcollector, pyinotify, python-dateutil
}:

buildPythonApplication rec {
  pname = "openstack-oslo_log";
  version = "4.6.0";

  src = fetchPypi {
    pname = "oslo.log";
    inherit version;
    sha256 = "dad5d7ff1290f01132b356d36a1bb79f98a3929d5005cce73e849ed31b385ba7";
  };

  propagatedBuildInputs = [
    pbr
    openstack-oslo_config
    openstack-oslo_context
    openstack-oslo_i18n
    openstack-oslo_utils
    openstack-oslo_serialization
    openstack-debtcollector
    pyinotify
    python-dateutil
  ];

  doCheck = false;

  pythonImportsCheck = [ "oslo_log" ];

  meta = with lib; {
    description = "Oslo Logging Library";
    downloadPage = "https://pypi.org/project/oslo.log/";
    homepage = "https://github.com/openstack/oslo.log";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
