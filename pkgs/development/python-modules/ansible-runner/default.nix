{
  lib,
  stdenv,
  ansible-core,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  glibcLocales,
  importlib-metadata,
  mock,
  openssh,
  pbr,
  pexpect,
  psutil,
  pytest-mock,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  python-daemon,
  pyyaml,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "ansible-runner";
  version = "2.3.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-shdKEtytLcLzQuqCh2iY9WigtmxTVoYAv4BXcVj8uhw=";
  };

  patches = [
    (fetchpatch {
      name = "fix-tests.patch";
      url = "https://github.com/ansible/ansible-runner/commit/0d522c90cfc1f305e118705a1b3335ccb9c1633d.patch";
      hash = "sha256-eTnQkftvjK0YHU+ovotRVSuVlvaVeXp5SvYk1DPCg88=";
      excludes = [
        ".github/workflows/ci.yml"
        "tox.ini"
      ];
    })
    (fetchpatch {
      # python 3.12 compat
      url = "https://github.com/ansible/ansible-runner/commit/dc248497bb2375a363222ce755bf3a31f21d5f64.patch";
      hash = "sha256-QT28Iw0uENoO35rqZpYBcmJB/GNDEF4m86SKf6p0XQU=";
    })
  ];

  build-system = [
    setuptools
    pbr
  ];

  dependencies = [
    ansible-core
    psutil
    pexpect
    python-daemon
    pyyaml
    six
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
    # Requires network access
    "test_callback_plugin_task_args_leak"
    "test_env_accuracy"
    # Times out on slower hardware
    "test_large_stdout_blob"
    # Failed: DID NOT RAISE <class 'RuntimeError'>
    "test_validate_pattern"
  ];

  disabledTestPaths =
    [
      # These tests unset PATH and then run executables like `bash` (see https://github.com/ansible/ansible-runner/pull/918)
      "test/integration/test_runner.py"
      "test/unit/test_runner.py"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Integration tests on Darwin are not regularly passing in ansible-runner's own CI
      "test/integration"
      # These tests write to `/tmp` which is not writable on Darwin
      "test/unit/config/test__base.py"
    ];

  pythonImportsCheck = [ "ansible_runner" ];

  meta = with lib; {
    description = "Helps when interfacing with Ansible";
    mainProgram = "ansible-runner";
    homepage = "https://github.com/ansible/ansible-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
