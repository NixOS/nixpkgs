{ lib, buildPythonPackage, fetchPypi
, isPy3k, python
, pbr, requests, six, futures
, testtools, testrepository, mock
, keystoneauth1
}:
buildPythonPackage rec {
  pname = "python-swiftclient";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z86a69hrj4fgjr68ag6wxg20wdsan7cjvjpvnay4xnhkcrsxxsl";
  };

  propagatedBuildInputs = [
    pbr requests six
  ] ++ lib.optional (!isPy3k) futures ;
  buildInputs = [
    testtools testrepository mock keystoneauth1
  ];

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  meta = with lib; {
    description = "Python bindings to the OpenStack Object Storage API";
    homepage = "http://www.openstack.org/";
  };
}

