{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  click,
  distro,
  gevent,
  jinja2,
  packaging,
  paramiko,
  pydantic,
  python-dateutil,
  typeguard,
  types-paramiko,

  # tests
  freezegun,
  pyinfra-testgen,
  pytest-testinfra,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyinfra";
  version = "3.8.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Fizzadar";
    repo = "pyinfra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0DIG1Msttg7tqLbCZKi07uWTg3KYgH9rVlWPeJs4wwA=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    click
    distro
    gevent
    jinja2
    packaging
    paramiko
    pydantic
    python-dateutil
    typeguard
    types-paramiko
  ];

  nativeCheckInputs = [
    freezegun
    pyinfra-testgen
    pytest-testinfra
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "pyinfra" ];

  disabledTests = [
    # Test requires SSH binary
    "test_load_ssh_config"
  ];

  meta = {
    description = "Python-based infrastructure automation";
    longDescription = ''
      pyinfra automates/provisions/manages/deploys infrastructure. It can be used for
      ad-hoc command execution, service deployment, configuration management and more.
    '';
    homepage = "https://pyinfra.com";
    downloadPage = "https://pyinfra.com/Fizzadar/pyinfra/releases";
    changelog = "https://github.com/Fizzadar/pyinfra/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ totoroot ];
    mainProgram = "pyinfra";
  };
})
