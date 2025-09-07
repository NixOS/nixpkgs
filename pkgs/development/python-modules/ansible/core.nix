{
  lib,
  buildPythonPackage,
  fetchPypi,
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

buildPythonPackage rec {
  pname = "ansible-core";
  # IMPORTANT: When bumping the minor version (2.XX.0 - the XX), please update pinned package in pkgs/top-level/all-packages.nix
  # There are pinned packages called ansible_2_XX, create a new one with the previous minor version and then update the version here
  version = "2.19.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchPypi {
    pname = "ansible_core";
    inherit version;
    hash = "sha256-r/0zs40ytXz8LNba86r8s4QpcDnkxWABlqLumqAnt10=";
  };

  # ansible_connection is already wrapped, so don't pass it through
  # the python interpreter again, as it would break execution of
  # connection plugins.
  postPatch = ''
    patchShebangs --build packaging/cli-doc/build.py

    SETUPTOOLS_PATTERN='"setuptools[0-9 <>=.,]+"'
    PYPROJECT=$(cat pyproject.toml)
    if [[ "$PYPROJECT" =~ $SETUPTOOLS_PATTERN ]]; then
      echo "setuptools replace: ''${BASH_REMATCH[0]}"
      echo "''${PYPROJECT//''${BASH_REMATCH[0]}/'"setuptools"'}" > pyproject.toml
    else
      exit 2
    fi

    substituteInPlace pyproject.toml \
      --replace-fail "wheel == 0.45.1" wheel
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

  # internal import errors, missing dependencies
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/ansible/ansible/blob/v${version}/changelogs/CHANGELOG-v${lib.versions.majorMinor version}.rst";
    description = "Radically simple IT automation";
    homepage = "https://www.ansible.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      HarisDotParis
      robsliwi
    ];
  };
}
