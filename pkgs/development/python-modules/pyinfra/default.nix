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
  pyinfra-testing,
  pytest-testinfra,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyinfra";
  version = "3.10.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pyinfra-dev";
    repo = "pyinfra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b1z6ZHt/fbDplJXZMx3/Ao/I9f4KHJcG1hmnWCLJJwY=";
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
    pytest-testinfra
    pyinfra-testing
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "pyinfra" ];

  pythonRelaxDeps = [
    "paramiko"
    "types-paramiko"
  ];

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
    changelog = "https://github.com/pyinfra-dev/pyinfra/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      robsliwi
      totoroot
    ];
    mainProgram = "pyinfra";
  };
})
