{ lib
, callPackage
, buildPythonPackage
, fetchPypi
, installShellFiles
, ansible
, cryptography
, jinja2
, junit-xml
, lxml
, ncclient
, packaging
, paramiko
, pexpect
, psutil
, pycrypto
, pyyaml
, requests
, resolvelib
, scp
, windowsSupport ? false, pywinrm
, xmltodict
}:

buildPythonPackage rec {
  pname = "ansible-core";
  version = "2.12.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HMyZRPEBMxra0e1A1axmqBSRMwUq402wJnp0qnO+67M=";
  };

  # ansible_connection is already wrapped, so don't pass it through
  # the python interpreter again, as it would break execution of
  # connection plugins.
  postPatch = ''
    substituteInPlace lib/ansible/executor/task_executor.py \
      --replace "[python," "["
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    # depend on ansible instead of the other way around
    ansible
    # from requirements.txt
    cryptography
    jinja2
    packaging
    pyyaml
    resolvelib
    # optional dependencies
    junit-xml
    lxml
    ncclient
    paramiko
    pexpect
    psutil
    pycrypto
    requests
    scp
    xmltodict
  ] ++ lib.optional windowsSupport pywinrm;

  postInstall = ''
    installManPage docs/man/man1/*.1
  '';

  # internal import errors, missing dependencies
  doCheck = false;

  meta = with lib; {
    description = "Radically simple IT automation";
    homepage = "https://www.ansible.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
