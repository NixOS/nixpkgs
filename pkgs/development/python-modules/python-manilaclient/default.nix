{ lib
, buildPythonPackage
, fetchPypi
, installShellFiles
, pbr
, openstackdocstheme
, oslo-config
, oslo-log
, oslo-serialization
, oslo-utils
, prettytable
, requests
, simplejson
, sphinx
, sphinxcontrib-programoutput
, babel
, osc-lib
, python-keystoneclient
, debtcollector
, callPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-manilaclient";
  version = "4.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yoyQyhyqRQZ8yyn3sv94JqkVZQMybwxLGFForZowr3o=";
  };

  nativeBuildInputs = [
    installShellFiles
    openstackdocstheme
    sphinx
    sphinxcontrib-programoutput
  ];

  propagatedBuildInputs = [
    pbr
    oslo-config
    oslo-log
    oslo-serialization
    oslo-utils
    prettytable
    requests
    simplejson
    babel
    osc-lib
    python-keystoneclient
    debtcollector
  ];

  postInstall = ''
    export PATH=$out/bin:$PATH
    sphinx-build -a -E -d doc/build/doctrees -b man doc/source doc/build/man
    installManPage doc/build/man/python-manilaclient.1
  '';

  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [
    "manilaclient"
  ];

  meta = with lib; {
    description = "Client library for OpenStack Manila API";
    homepage = "https://github.com/openstack/python-manilaclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
