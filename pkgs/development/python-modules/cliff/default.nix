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
  version = "3.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c68aac08d0d25853234a38fdbf1f33503849af3d5d677a4d0aacd42b0be6a4a1";
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
