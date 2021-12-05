{ lib, buildPythonPackage, fetchPypi, setuptools, callPackage }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dvkqixz227bhhk7c9r2bwcm7kmkfqyxw1bkha0jf3z88laclla6";
  };

  propagatedBuildInputs = [ setuptools ];

  # check in passthru.tests.pytest to escape infinite recursion with fixtures
  doCheck = false;

  passthru.tests = { tests = callPackage ./tests.nix { }; };

  pythonImportsCheck = [ "pbr" ];

  meta = with lib; {
    description = "Python Build Reasonableness";
    homepage = "https://github.com/openstack/pbr";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
