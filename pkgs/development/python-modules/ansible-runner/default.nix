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
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zys65vq0jqyzdmchaydzsvlf0ysw2y58sapjq6wzc6yw6pdyigz";
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
