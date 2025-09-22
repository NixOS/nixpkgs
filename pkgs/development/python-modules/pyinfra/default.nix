{
  lib,
  buildPythonPackage,
  click,
  distro,
  fetchFromGitHub,
  gevent,
  importlib-metadata,
  jinja2,
  packaging,
  paramiko,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pywinrm,
  setuptools,
  typeguard,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pyinfra";
  version = "3.4.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Fizzadar";
    repo = "pyinfra";
    tag = "v${version}";
    hash = "sha256-7bNkDm5SyIgVkrGQ95/q7AiY/JnxtWx+jkDO/rJQ2WQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    distro
    gevent
    jinja2
    packaging
    paramiko
    python-dateutil
    pywinrm
    setuptools
    typeguard
  ]
  ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ]
  ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

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
    changelog = "https://github.com/Fizzadar/pyinfra/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
    mainProgram = "pyinfra";
  };
}
