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
    version = "4.2.0";
    sha256 = "1l30j97q24klylchvbskdmp1xllswn9xskjvg4l0ra6pzfgq2zbk";
  };
in
buildPythonPackage rec {
  pname = "ansible-core";
  version = "2.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DO0bT2cZftsntQk0yV1MtkTG1jXXLH+CbEQl3+RTdnQ=";
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
