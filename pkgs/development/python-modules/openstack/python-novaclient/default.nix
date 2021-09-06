{ lib, buildPythonApplication, fetchPypi, callPackage
, pbr, openstack-keystoneauth1, iso8601, openstack-oslo_i18n, openstack-oslo_serialization, openstack-oslo_utils, prettytable, stevedore
}:

buildPythonApplication rec {
  pname = "openstack-python-novaclient";
  version = "17.6.0";

  src = fetchPypi {
    pname = "python-novaclient";
    inherit version;
    sha256 = "c910c2085310da635fb343585f1070712ff0f9cb3c8f79d44ca3d632c4f230f5";
  };

  propagatedBuildInputs = [
    pbr
    openstack-keystoneauth1
    iso8601
    openstack-oslo_i18n
    openstack-oslo_serialization
    openstack-oslo_utils
    prettytable
    stevedore
  ];

  checkPhase = ''
    runHook preCheck
    $out/bin/nova --version | grep ${version} > /dev/null
    runHook postCheck
  '';

  pythonImportsCheck = [ "novaclient" ];

  meta = with lib; {
    description = "A client for the OpenStack Compute API";
    downloadPage = "https://pypi.org/project/python-novaclient/";
    homepage = "https://github.com/openstack/python-novaclient";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
