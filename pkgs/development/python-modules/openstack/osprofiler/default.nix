{ lib, buildPythonApplication, fetchPypi, callPackage
, netaddr, openstack-oslo_concurrency, openstack-oslo_serialization, openstack-oslo_utils, prettytable, requests, six, webob, importlib-metadata
}:

buildPythonApplication rec {
  pname = "osprofiler";
  version = "3.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e324c4c45bf40dc62f865a0be9315190e124b840bbdd6499e42571f2fe1df36";
  };

  propagatedBuildInputs = [
    netaddr
    openstack-oslo_concurrency
    openstack-oslo_serialization
    openstack-oslo_utils
    prettytable
    requests
    six
    webob
  ];

  doCheck = false;

  pythonImportsCheck = [ "osprofiler" ];

  meta = with lib; {
    description = "Library for cross-project profiling";
    downloadPage = "https://pypi.org/project/osprofiler/";
    homepage = "https://github.com/openstack/osprofiler";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
