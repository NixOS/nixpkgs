{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  installShellFiles,
  docutils,
  ansible,
  cryptography,
  importlib-resources,
  jinja2,
  junit-xml,
  lxml,
  ncclient,
  packaging,
  paramiko,
  ansible-pylibssh,
  passlib,
  pexpect,
  psutil,
  pycrypto,
  pyyaml,
  requests,
  resolvelib,
  scp,
  windowsSupport ? false,
  pywinrm,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "ansible-core";
  version = "2.17.3";

  src = fetchPypi {
    pname = "ansible_core";
    inherit version;
    hash = "sha256-kXVXBlM5/jbnB46b6kfu+rbWh3871DX6Xw12bQTFhIU=";
  };

  # ansible_connection is already wrapped, so don't pass it through
  # the python interpreter again, as it would break execution of
  # connection plugins.
  postPatch = ''
    substituteInPlace lib/ansible/executor/task_executor.py \
      --replace "[python," "["

    patchShebangs --build packaging/cli-doc/build.py
  '';

  nativeBuildInputs = [
    installShellFiles
    docutils
  ];

  propagatedBuildInputs =
    [
      # depend on ansible instead of the other way around
      ansible
      # from requirements.txt
      cryptography
      jinja2
      packaging
      passlib
      pyyaml
      resolvelib
      # optional dependencies
      junit-xml
      lxml
      ncclient
      paramiko
      ansible-pylibssh
      pexpect
      psutil
      pycrypto
      requests
      scp
      xmltodict
    ]
    ++ lib.optionals windowsSupport [ pywinrm ]
    ++ lib.optionals (pythonOlder "3.10") [ importlib-resources ];

  pythonRelaxDeps = lib.optionals (pythonOlder "3.10") [ "importlib-resources" ];

  postInstall = ''
    export HOME="$(mktemp -d)"
    packaging/cli-doc/build.py man --output-dir=man
    installManPage man/*
  '';

  # internal import errors, missing dependencies
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/ansible/ansible/blob/v${version}/changelogs/CHANGELOG-v${lib.versions.majorMinor version}.rst";
    description = "Radically simple IT automation";
    homepage = "https://www.ansible.com";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
