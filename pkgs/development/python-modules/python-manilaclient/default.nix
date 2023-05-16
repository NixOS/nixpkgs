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
}:

buildPythonPackage rec {
  pname = "python-manilaclient";
<<<<<<< HEAD
  version = "4.6.0";
=======
  version = "4.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-JFdpPX2lVSGN/jVsKMOOKrPm51fwpD476TnQo/0AYWQ=";
=======
    hash = "sha256-iKBbR4h9J9OiQMHjUHxUVk+NbCRUYmIPtWxRwVVGQtY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
