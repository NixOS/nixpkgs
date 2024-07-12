{
  lib,
  buildPythonPackage,
  click,
  colorama,
  configparser,
  distro,
  fetchFromGitHub,
  gevent,
  jinja2,
  packaging,
  paramiko,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pywinrm,
  pyyaml,
  setuptools,
  typeguard,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pyinfra";
  version = "3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Fizzadar";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0IWfE8SAi9G9gWjRR7CMJ/72V3XW5Ho2acjE/YAooT0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    colorama
    configparser
    distro
    gevent
    jinja2
    packaging
    paramiko
    python-dateutil
    pywinrm
    pyyaml
    setuptools
    typeguard
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyinfra" ];

  disabledTests = [
    # Test requires SSH binary
    "test_load_ssh_config"
  ];

  meta = with lib; {
    description = "Python-based infrastructure automation";
    mainProgram = "pyinfra";
    longDescription = ''
      pyinfra automates/provisions/manages/deploys infrastructure. It can be used for
      ad-hoc command execution, service deployment, configuration management and more.
    '';
    homepage = "https://pyinfra.com";
    downloadPage = "https://github.com/pyinfra-dev/pyinfra/releases";
    changelog = "https://github.com/pyinfra-dev/pyinfra/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ totoroot ];
    license = licenses.mit;
  };
}
