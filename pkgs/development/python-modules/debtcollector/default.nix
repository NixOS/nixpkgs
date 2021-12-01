{ lib, buildPythonPackage, fetchPypi, pbr, six, wrapt, callPackage }:

buildPythonPackage rec {
  pname = "debtcollector";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7a9fac814ab5904e23905516b18356cc907e7d27c05da58d37103f001967846";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ six wrapt ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "debtcollector" ];

  meta = with lib; {
    description = "A collection of Python deprecation patterns and strategies that help you collect your technical debt in a non-destructive manner";
    homepage = "https://github.com/openstack/debtcollector";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
