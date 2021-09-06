{ lib, buildPythonApplication, fetchPypi
, pbr, openstack-oslo_config, openstack-oslo_i18n, openstack-oslo_utils, fasteners
}:

buildPythonApplication rec {
  pname = "openstack-oslo_concurrency";
  version = "4.4.0";

  src = fetchPypi {
    pname = "oslo.concurrency";
    inherit version;
    sha256 = "0d1d0a341ead03f4e5638c368de99baacd943011c5cceece43106885470edf69";
  };

  propagatedBuildInputs = [
    pbr
    openstack-oslo_config
    openstack-oslo_i18n
    openstack-oslo_utils
    fasteners
  ];

  doCheck = false;

  pythonImportsCheck = [ "oslo_concurrency" ];

  meta = with lib; {
    description = "A library with utilities for safely running multi-thread, multi-process applications using locking mechanisms and for running external processes.";
    downloadPage = "https://github.com/openstack/oslo.concurrency";
    homepage = "https://docs.openstack.org/oslo.concurrency/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
