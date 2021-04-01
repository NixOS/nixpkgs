{ lib
, fetchFromGitHub
, buildPythonPackage
, pycrypto
, paramiko
, jinja2
, pyyaml
, httplib2
, six
, netaddr
, dnspython
, jmespath
, dopy
, ncclient
, installShellFiles
, windowsSupport ? false
, pywinrm
}:

buildPythonPackage rec {
  pname = "ansible";
  version = "2.9.12";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "ansible";
    rev = "v${version}";
    sha256 = "0c794k0cyl54807sh9in0l942ah6g6wlz5kf3qvy5lhd581zlgyb";
  };

  postPatch = ''
    # ansible-connection is wrapped, so make sure it's not passed
    # through the python interpreter.
    sed -i "s/\[python, /[/" lib/ansible/executor/task_executor.py
  '';

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    pycrypto paramiko jinja2 pyyaml httplib2
    six netaddr dnspython jmespath dopy ncclient
  ] ++ lib.optional windowsSupport pywinrm;

  # difficult to test
  doCheck = false;

  postInstall = ''
    installManPage docs/man/man*/*
  '';

  meta = with lib; {
    homepage = "https://www.ansible.com";
    description = "Radically simple IT automation";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ joamaki costrouc hexa ];
    platforms = platforms.unix;
  };
}
