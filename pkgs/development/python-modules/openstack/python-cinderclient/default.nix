{ lib, buildPythonApplication, fetchPypi, callPackage
, pbr, prettytable, openstack-keystoneauth1, simplejson, openstack-oslo_i18n, openstack-oslo_utils, requests, stevedore
}:

buildPythonApplication rec {
  pname = "openstack-python-cinderclient";
  version = "8.1.0";

  src = fetchPypi {
    pname = "python-cinderclient";
    inherit version;
    sha256 = "b57b432b2ac9161c2482a569a023211d2d3d0ada81c4da62c8f6e47f0b2bf82d";
  };

  propagatedBuildInputs = [
    pbr
    prettytable
    openstack-keystoneauth1
    simplejson
    openstack-oslo_i18n
    openstack-oslo_utils
    requests
    stevedore
  ];

  checkPhase = ''
    runHook preCheck
    $out/bin/cinder --version | grep ${version} > /dev/null
    runHook postCheck
  '';

  pythonImportsCheck = [ "cinderclient" ];

  meta = with lib; {
    description = "Python bindings and a client to the OpenStack Cinder API";
    downloadPage = "https://github.com/openstack/python-cinderclient";
    homepage = "https://github.com/openstack/python-cinderclient";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
