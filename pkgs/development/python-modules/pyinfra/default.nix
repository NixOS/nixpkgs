{
  lib,
  buildPythonPackage,
  click,
  distro,
  fetchFromGitHub,
  fetchpatch,
  freezegun,
  gevent,
  hatchling,
  jinja2,
  packaging,
  paramiko,
  pydantic,
  pyinfra-testgen,
  pytest-testinfra,
  pytestCheckHook,
  python-dateutil,
  typeguard,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "pyinfra";
  version = "3.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Fizzadar";
    repo = "pyinfra";
    tag = "v${version}";
    hash = "sha256-SB/V5pV10pBaYyYTp/Ty3J+/NX9oT3u++ZWELCk1qkc=";
  };

  patches = [
    # paramiko v4 compat
    # https://github.com/pyinfra-dev/pyinfra/pull/1525
    (fetchpatch {
      name = "remove-DSSKey.patch";
      url = "https://github.com/pyinfra-dev/pyinfra/commit/a655bdf425884055145cfd0011c3b444c9a3ada2.patch";
      hash = "sha256-puHcA4+KigltCL2tUYRMc9OT3kxvTeW77bbFbxgkcTs=";
    })
  ];

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "paramiko"
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
  ];

  nativeCheckInputs = [
    freezegun
    pyinfra-testgen
    pytest-testinfra
    pytestCheckHook
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
    changelog = "https://github.com/Fizzadar/pyinfra/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ totoroot ];
    mainProgram = "pyinfra";
  };
}
