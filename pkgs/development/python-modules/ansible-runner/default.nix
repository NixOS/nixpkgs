{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pyyaml
, python-daemon
, pexpect
, psutil
, pytest
, mock
, python
}:

buildPythonPackage rec {
  pname = "ansible-runner";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2376b39c7b4749e17e15a21844e37164d6df964c9f35f27aa679c0707b1f7b19";
  };

  checkInputs = [ pytest mock python ];
  propagatedBuildInputs = [ six pyyaml python-daemon pexpect psutil ];

  checkPhase = ''
    pytest test
  '';

  # tests fail due to python location during test
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stable and consistent interface abstraction to Ansible";
    homepage = https://github.com/ansible/ansible-runner;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
