{ lib, buildPythonPackage, fetchPypi, pbr, six, wrapt, callPackage }:

buildPythonPackage rec {
  pname = "debtcollector";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3J0a0/dFxD9LvtvKMPn/6JBajAKMmSbmEHeEfV6iV6s=";
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
