{ lib, buildPythonPackage, fetchPypi, pbr, six, wrapt, callPackage }:

buildPythonPackage rec {
  pname = "debtcollector";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KokX0lsOHx0NNl08HG7Px6UiselxbooaSpFRJvfM6m8=";
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
