{ lib
, buildPythonPackage
, fetchPypi
, psutil
, pexpect
, python-daemon
, pyyaml
, six
, stdenv
, ansible
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "ansible-runner";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c02b690803ec0be4453411c53743cd3fdca1dfc66dfa075794e14e717c5b61b3";
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

  # test_process_isolation_settings is currently broken on Darwin Catalina
  # https://github.com/ansible/ansible-runner/issues/413
  checkPhase = ''
    HOME=$TMPDIR pytest \
      --ignore test/unit/test_runner.py \
      -k "not prepare ${lib.optionalString stdenv.isDarwin "and not process_isolation_settings"}"
  '';

  meta = with lib; {
    description = "Helps when interfacing with Ansible";
    homepage = "https://github.com/ansible/ansible-runner";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
