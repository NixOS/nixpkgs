{
  lib,
  buildPythonPackage,
  decorator,
  deprecated,
  fetchFromGitHub,
  icecream,
  invoke,
  mock,
  paramiko,
  pytest-relaxed,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage {
  pname = "fabric";

  # Using an unstable version to add support for invoke v3: Nixpkgs only
  # provides that version, but fabric doesn't support invoke v3 in any released
  # version.
  # https://github.com/fabric/fabric/issues/2376
  version = "3.2.3-unstable-2026-04-07";

  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fabric";
    repo = "fabric";
    rev = "cc098ad475dbbe2e10aba72692d83aee58919570";
    hash = "sha256-Z1tGcjdLrzbqcbS6XwapSgDNpyLbBiO21yeqi7XhbpQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    invoke
    paramiko
    deprecated
    decorator
  ];

  nativeCheckInputs = [
    icecream
    mock
    pytest-relaxed
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/*.py" ];

  pythonImportsCheck = [ "fabric" ];

  disabledTests = [
    # Tests are out-dated
    "calls_RemoteShell_run_with_all_kwargs_and_returns_its_result"
    "executes_arguments_on_contents_run_via_threading"
    "expect"
    "from_v1"
    "honors_config_system_for_allowed_kwargs"
    "llows_disabling_remote_mode_preservation"
    "load"
    "preserves_remote_mode_by_default"
    "proxy_jump"
    "raises_TypeError_for_disallowed_kwargs"
    # Assertion failures on mocks
    # https://github.com/fabric/fabric/issues/2341
    "client_defaults_to_a_new_SSHClient"
    "defaults_to_auto_add"

    # Fixture "fake_agent" called directly. Fixtures are not meant to be called directly
    "no_stdin"
    "fake_agent"
    "fake"
  ];

  meta = {
    description = "Pythonic remote execution";
    homepage = "https://www.fabfile.org/";
    changelog = "https://www.fabfile.org/changelog.html";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "fab";
  };
}
