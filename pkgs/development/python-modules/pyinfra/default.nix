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
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Fizzadar";
    repo = "pyinfra";
    rev = "refs/tags/v${version}";
    hash = "sha256-Pjmh/aPsMIwGv5Agf+UGm1T3jv8i9jJQ7SEGc3vDxZg=";
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
  ] ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyinfra" ];

  disabledTests = [
    # Test requires SSH binary
    "test_load_ssh_config"
  ];

  meta = with lib; {
    description = "Python-based infrastructure automation";
    longDescription = ''
      pyinfra automates/provisions/manages/deploys infrastructure. It can be used for
      ad-hoc command execution, service deployment, configuration management and more.
    '';
    homepage = "https://pyinfra.com";
    downloadPage = "https://pyinfra.com/Fizzadar/pyinfra/releases";
    changelog = "https://github.com/Fizzadar/pyinfra/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
    mainProgram = "pyinfra";
  };
}
