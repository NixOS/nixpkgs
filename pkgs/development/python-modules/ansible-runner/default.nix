{
  lib,
  stdenv,
  ansible-core,
  buildPythonPackage,
  fetchPypi,
  glibcLocales,
  importlib-metadata,
  mock,
  openssh,
  packaging,
  pexpect,
  pytest-mock,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  python-daemon,
  pyyaml,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ansible-runner";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gtArJUiDDzelNRe2XII8SvNxBpQGx9ITtckEHUXgxbY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools>=45, <=69.0.2", "setuptools-scm[toml]>=6.2, <=8.0.4"' '"setuptools", "setuptools-scm"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    pexpect
    python-daemon
    pyyaml
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  nativeCheckInputs = [
    ansible-core # required to place ansible CLI onto the PATH in tests
    glibcLocales
    pytestCheckHook
    pytest-mock
    pytest-timeout
    pytest-xdist
    mock
    openssh
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH="$PATH:$out/bin";
    # avoid coverage flags
    rm pytest.ini
  '';

  disabledTests = [
    # Tests require network access
    "test_callback_plugin_task_args_leak"
    "test_env_accuracy"
    # Times out on slower hardware
    "test_large_stdout_blob"
    # Failed: DID NOT RAISE <class 'RuntimeError'>
    "test_validate_pattern"
    # Assertion error
    "test_get_role_list"
    "test_include_role_from_collection_events"
    "test_resolved_actions"
    "test_callback_plugin_censoring_does_not_overwrite"
  ];

  disabledTestPaths =
    [
      # These tests unset PATH and then run executables like `bash` (see https://github.com/ansible/ansible-runner/pull/918)
      "test/integration/test_runner.py"
      "test/unit/test_runner.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Integration tests on Darwin are not regularly passing in ansible-runner's own CI
      "test/integration"
      # These tests write to `/tmp` which is not writable on Darwin
      "test/unit/config/test__base.py"
    ];

  pythonImportsCheck = [ "ansible_runner" ];

  meta = with lib; {
    description = "Helps when interfacing with Ansible";
    homepage = "https://github.com/ansible/ansible-runner";
    changelog = "https://github.com/ansible/ansible-runner/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "ansible-runner";
  };
}
