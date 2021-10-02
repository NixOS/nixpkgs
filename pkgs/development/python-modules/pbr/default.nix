{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, callPackage
}:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42df03e7797b796625b1029c0400279c7c34fd7df24a7d7818a1abb5b38710dd";
  };

  propagatedBuildInputs = [ setuptools ];

  # check in passthru.tests.pytest to escape infinite recursion with fixtures
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "pbr" ];

  meta = with lib; {
    description = "Python Build Reasonableness";
    homepage = "https://github.com/openstack/pbr";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
