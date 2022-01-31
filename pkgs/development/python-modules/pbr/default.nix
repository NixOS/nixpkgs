{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, callPackage
}:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "672d8ebee84921862110f23fcec2acea191ef58543d34dfe9ef3d9f13c31cddf";
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
