{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  platformdirs,
  jinja2,
  overrides,
  pyyaml,
  setuptools-scm,
  pytest-check,
  pytest-mock,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "craft-cli";
  version = "3.0.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-cli";
    tag = version;
    hash = "sha256-RAnvx5519iXZnJm8jtY635e0DEL7jnIgZtTCindqMTY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==75.2.0" "setuptools"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    jinja2
    overrides
    platformdirs
    pyyaml
  ];

  pythonImportsCheck = [ "craft_cli" ];

  nativeCheckInputs = [
    pytest-check
    pytest-mock
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pytestFlagsArray = [ "tests/unit" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI builder for Canonical's CLI Guidelines";
    homepage = "https://github.com/canonical/craft-cli";
    changelog = "https://github.com/canonical/craft-cli/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
