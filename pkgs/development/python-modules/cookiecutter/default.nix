{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  bash,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  freezegun,
  git,
  jinja2,
  binaryornot,
  click,
  jinja2-time,
  requests,
  python-slugify,
  pyyaml,
  arrow,
  rich,
}:

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "2.7.1";
  pyproject = true;

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ynu3vIxv9EH79TkhtVN2aAAOONVuKNdjobc5dcZsYTg=";
  };

  postPatch = ''
    patchShebangs tests/test-pyshellhooks/hooks tests/test-shellhooks/hooks

    substituteInPlace tests/test_hooks.py \
      --replace-fail "/bin/bash" "${lib.getExe bash}"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    freezegun
    git
  ];

  dependencies = [
    binaryornot
    jinja2
    click
    pyyaml
    jinja2-time
    python-slugify
    requests
    arrow
    rich
  ];

  pythonImportsCheck = [ "cookiecutter.main" ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  disabledTests = [
    # messes with $PYTHONPATH
    "test_should_invoke_main"
  ];

  meta = {
    homepage = "https://github.com/audreyr/cookiecutter";
    changelog = "https://github.com/cookiecutter/cookiecutter/blob/${version}/HISTORY.md";
    description = "Command-line utility that creates projects from project templates";
    mainProgram = "cookiecutter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kragniz ];
  };
}
