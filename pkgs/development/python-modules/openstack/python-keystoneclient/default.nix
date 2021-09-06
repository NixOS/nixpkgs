{ lib, buildPythonApplication, fetchPypi
, pbr, openstack-debtcollector, openstack-keystoneauth1, openstack-oslo_config, openstack-oslo_i18n, openstack-oslo_serialization, openstack-oslo_utils, requests, six, stevedore
}:

buildPythonApplication rec {
  pname = "openstack-python-keystoneclient";
  version = "4.2.0";

  src = fetchPypi {
    pname = "python-keystoneclient";
    inherit version;
    sha256 = "0248426e483b95de395086482c077d48e45990d3b1a3e334b2ec8b2e108f5a8a";
  };

  propagatedBuildInputs = [
    pbr
    openstack-debtcollector
    openstack-keystoneauth1
    openstack-oslo_config
    openstack-oslo_i18n
    openstack-oslo_serialization
    openstack-oslo_utils
    requests
    six
    stevedore
  ];

  doCheck = false;

  pythonImportsCheck = [ "keystoneclient" ];

  meta = with lib; {
    description = "Python bindings to the OpenStack Identity API (Keystone)";
    downloadPage = "https://pypi.org/project/python-keystoneclient/";
    homepage = "https://docs.openstack.org/python-keystoneclient/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
