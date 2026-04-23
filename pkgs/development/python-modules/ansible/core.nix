{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  installShellFiles,
  docutils,
  setuptools,
  ansible,
  cryptography,
  jinja2,
  junit-xml,
  lxml,
  ncclient,
  packaging,
  paramiko,
  ansible-pylibssh,
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
  # Additional packages to add to dependencies
  extraPackages ? _: [ ],
}:

buildPythonPackage (finalAttrs: {
  pname = "ansible-core";
  version = "2.20.4";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "ansible";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7KsxZH1d5FfdnsYfKSNGCmdYuBi8KzZxyZbG2WNAM9Y=";
  };

  postPatch = ''
    patchShebangs --build packaging/cli-doc/build.py

    SETUPTOOLS_PATTERN='"setuptools[0-9 <>=.,]+"'
    WHEEL_PATTERN='"wheel[0-9 <>=.,]+"'
    echo "Patching pyproject.toml"
    # print replaced patterns to stdout
    sed -r -i -e 's/'"$SETUPTOOLS_PATTERN"'/"setuptools"/w /dev/stdout' \
      -e 's/'"$WHEEL_PATTERN"'/"wheel"/w /dev/stdout' pyproject.toml
  '';

  nativeBuildInputs = [
    installShellFiles
    docutils
  ];

  build-system = [ setuptools ];

  dependencies = [
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
    ansible-pylibssh
    pexpect
    psutil
    pycrypto
    requests
    scp
    xmltodict
  ]
  ++ lib.optionals windowsSupport [ pywinrm ]
  ++ extraPackages python.pkgs;

  pythonRelaxDeps = [ "resolvelib" ];

  postInstall = ''
    export HOME="$(mktemp -d)"
    packaging/cli-doc/build.py man --output-dir=man
    installManPage man/*
  '';

  postFixup = ''
    patchPythonScript $out/${python.sitePackages}/ansible/cli/scripts/ansible_connection_cli_stub.py
  '';

  # internal import errors, missing dependencies
  doCheck = false;

  meta = {
    changelog = "https://github.com/ansible/ansible/blob/v${finalAttrs.version}/changelogs/CHANGELOG-v${lib.versions.majorMinor finalAttrs.version}.rst";
    description = "Radically simple IT automation";
    homepage = "https://www.ansible.com";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      HarisDotParis
      robsliwi
    ];
  };
})
