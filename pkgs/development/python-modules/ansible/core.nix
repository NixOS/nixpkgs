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
, resolvelib
, scp
, windowsSupport ? false, pywinrm
, xmltodict
}:

let
  ansible-collections = callPackage ./collections.nix {
    version = "4.1.0";
    sha256 = "0rrivq1g0vizah8zmf012lzig2xxfk5x1371k16s3nn4zfkwqqgm";
  };
in
buildPythonPackage rec {
  pname = "ansible-core";
  version = "2.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1syadgzn5ww5bhq9s2py4h1hkh11h7aac5b37zi8rw2xfvdc7r2s";
  };

  # ansible_connection is already wrapped, so don't pass it through
  # the python interpreter again, as it would break execution of
  # connection plugins.
  postPatch = ''
    substituteInPlace lib/ansible/executor/task_executor.py \
      --replace "[python," "["

    substituteInPlace requirements.txt \
      --replace "resolvelib >= 0.5.3, < 0.6.0" "resolvelib"
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
