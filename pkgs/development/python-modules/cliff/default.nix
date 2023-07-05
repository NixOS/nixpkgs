{ lib
, autopage
, buildPythonPackage
, callPackage
, cmd2
, fetchPypi
, importlib-metadata
, installShellFiles
, openstackdocstheme
, pbr
, prettytable
, pyparsing
, pythonOlder
, pyyaml
, sphinx
, stevedore
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "4.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/FtuvI+4FTMncLJIXuNsCXU5N8N8zk8yJ83U4Qsz6sw=";
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
    importlib-metadata
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

  # Check is done in passthru.tests.pytest to escape infinite recursion with stestr
  doCheck = false;

  pythonImportsCheck = [
    "cliff"
  ];

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
