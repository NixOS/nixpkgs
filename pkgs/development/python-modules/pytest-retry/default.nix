{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-retry";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "str0zzapreti";
    repo = "pytest-retry";
    tag = version;
    hash = "sha256-Gf+L7zvC1FGAm0Wd6E6fV3KynassoGyHSD0CPgEJ02k=";
  };

  build-system = [ setuptools ];

  dependencies = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_retry" ];

  meta = {
    description = "Plugin for retrying flaky tests in CI environments";
    longDescription = ''
      This plugin adds a decorator to mark tests as flaky: `@pytest.mark.flaky(retries=3, delay=1)`.
    '';
    homepage = "https://github.com/str0zzapreti/pytest-retry";
    changelog = "https://github.com/str0zzapreti/pytest-retry/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fliegendewurst ];
  };
}
