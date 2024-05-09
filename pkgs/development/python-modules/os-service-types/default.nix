{ lib
, buildPythonPackage
, fetchPypi
, pbr
, six
, callPackage
}:

buildPythonPackage rec {
  pname = "os-service-types";
  version = "1.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  propagatedBuildInputs = [ pbr six ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "os_service_types" ];

  meta = with lib; {
    description = "Python library for consuming OpenStack service-types-authority data";
    homepage = "https://github.com/openstack/os-service-types";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
