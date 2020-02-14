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
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6ccb7ccf9bab9c49a391db37e0d399ba0e73f969801ae35ff74020bfd4fc346";
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
