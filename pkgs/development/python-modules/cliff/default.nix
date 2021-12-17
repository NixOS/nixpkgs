{ lib
, buildPythonPackage
, fetchPypi
, autopage
, cmd2
, pbr
, prettytable
, pyparsing
, pyyaml
, stevedore
, callPackage
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "3.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95363e9b43e2ec9599e33b5aea27a6953beda2d0673557916fa4f5796857daa3";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  propagatedBuildInputs = [
    autopage
    cmd2
    pbr
    prettytable
    pyparsing
    pyyaml
    stevedore
  ];

  # check in passthru.tests.pytest to escape infinite recursion with stestr
  doCheck = false;

  pythonImportsCheck = [ "cliff" ];

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://github.com/openstack/cliff";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
