{ lib
, buildPythonPackage
, fetchPypi
, psutil
, pexpect
, python-daemon
, pyyaml
, six
, ansible
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "ansible-runner";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9db56a69ad5d43fe7656ad8efb4083cb1800ea400f7828af6b20f44c0882404f";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [
    ansible
    psutil
    pexpect
    python-daemon
    pyyaml
    six
  ];

  checkPhase = ''
    HOME=$(mktemp -d) pytest --ignore test/unit/test_runner.py -k "not test_prepare"
  '';

  meta = with lib; {
    description = "Helps when interfacing with Ansible";
    homepage = https://github.com/ansible/ansible-runner;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
