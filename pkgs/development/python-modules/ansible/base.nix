{ lib
, callPackage
, buildPythonPackage
, fetchPypi
, installShellFiles
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
, scp
, windowsSupport ? false, pywinrm
, xmltodict
}:

let
  ansible-collections = callPackage ./collections.nix {
    version = "3.4.0"; # must be < 4.0
    sha256 = "096rbgz730njk0pg8qnc27mmz110wqrw354ca9gasb7rqg0f4d6a";
  };
in
buildPythonPackage rec {
  pname = "ansible-base";
  version = "2.10.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-75JYgsqNTDwszQkc3hmeDIaQJMytDQejN9zyB7/zLzQ=";
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
    # depend on ansible-collections instead of the other way around
    ansible-collections
    # from requirements.txt
    cryptography
    jinja2
    packaging
    pyyaml
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

  passthru = {
    collections = ansible-collections;
  };

  meta = with lib; {
    description = "Radically simple IT automation";
    homepage = "https://www.ansible.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
