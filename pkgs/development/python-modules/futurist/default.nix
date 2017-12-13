{ lib, fetchPypi, buildPythonPackage
# buildInputs
, futures
, prettytable
, contextlib2
, monotonic
, six
, pbr
# checkInputs
, eventlet
, doc8
, coverage
, subunit
, sphinx
, openstackdocstheme
, oslotest
, testrepository
, testscenarios
, testtools
, reno
}:

buildPythonPackage rec {
  pname = "futurist";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i2y1acvh2hvwkkqqh9kwhh2z3c2sgxi839jx31y9ipmccm5f0zq";
  };

  propagatedBuildInputs = [
    futures
    prettytable
    contextlib2
    monotonic
    six
    pbr
  ];

  # eventlet: socket.getprotobyname('tcp')
  doCheck = false;

  checkInputs = [
    eventlet
    doc8
    coverage
    subunit
    sphinx
    openstackdocstheme
    oslotest
    testrepository
    testscenarios
    testtools
    reno
  ];

  meta = with lib; {
    description = "Useful additions to futures, from the future";
    homepage = "https://docs.openstack.org/futurist/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
