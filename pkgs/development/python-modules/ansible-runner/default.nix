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
  version = "1.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53605de32f7d3d3442a6deb8937bf1d9c1f91c785e3f71003d22c3e63f85c71d";
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
