{ lib, buildPythonApplication, fetchPypi, pythonOlder
, fixtures, subunit, six, testtools
}:

buildPythonApplication rec {
  pname = "openstack-oslotest";
  version = "4.4.1";

  src = fetchPypi {
    pname = "oslotest";
    inherit version;
    sha256 = "b1c4f6530685a1872c446b1a9e2ec138861f11bafacc30b7d892a25acad7a064";
  };

  propagatedBuildInputs = [
    fixtures
    subunit
    six
    testtools
  ];

  doCheck = false;

  pythonImportsCheck = [ "oslotest" ];

  meta = with lib; {
    description = "Oslo test framework";
    downloadPage = "https://pypi.org/project/oslotest/";
    homepage = "https://github.com/openstack/oslotest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
