{ lib, buildPythonApplication, fetchPypi, callPackage
, openstack-pbr, openstack-oslo_config, openstack-oslo_log, openstack-oslo_serialization, openstack-oslo_utils, prettytable, requests, simplejson, Babel, openstack-osc-lib, openstack-python-keystoneclient, openstack-debtcollector
}:

buildPythonApplication rec {
  pname = "openstack-python-manilaclient";
  version = "3.0.0";

  src = fetchPypi {
    pname = "python-manilaclient";
    inherit version;
    sha256 = "2d90af35c5beccc53fa6b0f5a3c4b330a065e86924c33c42b017f18943ab2b05";
  };

  propagatedBuildInputs = [
    openstack-pbr
    openstack-oslo_config
    openstack-oslo_log
    openstack-oslo_serialization
    openstack-oslo_utils
    prettytable
    requests
    simplejson
    Babel
    openstack-osc-lib
    openstack-python-keystoneclient
    openstack-debtcollector
  ];

  checkPhase = ''
    runHook preCheck
    $out/bin/manila --version | grep ${version} > /dev/null
    runHook postCheck
  '';

  pythonImportsCheck = [ "manilaclient" ];

  meta = with lib; {
    description = "Client library for OpenStack Manila API";
    downloadPage = "https://pypi.org/project/python-manilaclient/";
    homepage = "https://github.com/openstack/python-manilaclient";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
