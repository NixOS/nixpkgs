{ lib, buildPythonApplication, fetchPypi, callPackage
, pbr, cliff, openstack-keystoneauth1, openstack-sdk, openstack-oslo_i18n, openstack-oslo_utils, simplejson, stevedore
}:

buildPythonApplication rec {
  pname = "openstack-osc-lib";
  version = "2.4.2";

  src = fetchPypi {
    pname = "osc-lib";
    inherit version;
    sha256 = "d6b530e3e50646840a6a5ef134e00f285cc4a04232c163f28585226ed40cc968";
  };

  propagatedBuildInputs = [
    pbr
    cliff
    openstack-keystoneauth1
    openstack-sdk
    openstack-oslo_i18n
    openstack-oslo_utils
    simplejson
    stevedore
  ];

  doCheck = false;

  pythonImportsCheck = [ "osc_lib" ];

  meta = with lib; {
    description = "A package of common support modules for writing OpenStackClient plugins.";
    downloadPage = "https://pypi.org/project/osc-lib/";
    homepage = "https://github.com/openstack/osc-lib";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
