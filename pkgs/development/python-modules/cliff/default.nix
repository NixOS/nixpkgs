{ lib
, buildPythonPackage
, fetchPypi
, autopage
, cmd2
, installShellFiles
, openstackdocstheme
, pbr
, prettytable
, pyparsing
, pyyaml
, stevedore
, sphinx
, callPackage
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "3.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BFruPzxkRxll161QfOhHSk4vIIFfu1QFp3D4WWoqAKA=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  nativeBuildInputs = [
    installShellFiles
    openstackdocstheme
    sphinx
  ];

  propagatedBuildInputs = [
    autopage
    cmd2
    pbr
    prettytable
    pyparsing
    pyyaml
    stevedore
  ];

  postInstall = ''
    sphinx-build -a -E -d doc/build/doctrees -b man doc/source doc/build/man
    installManPage doc/build/man/cliff.1
  '';

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
