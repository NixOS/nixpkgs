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
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c2fc02bd22ac831138bfd2241e1664d7700bbb2c61f96b8b1f2d83ab4ea59a7";
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
