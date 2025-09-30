{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  replaceVars,
  gdb,
  lldb,
  setuptools,
  pytestCheckHook,
  pytest-xdist,
  pytest-timeout,
  pytest-retry,
  importlib-metadata,
  psutil,
  untangle,
  django,
  flask,
  gevent,
  numpy,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "debugpy";
  version = "1.8.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "debugpy";
    tag = "v${version}";
    hash = "sha256-U9WeWAX0qDusWcMsFaI1ct4YKlGQEHUYlKZfRiYhma0=";
  };

  patches = [
    # Use nixpkgs version instead of versioneer
    (replaceVars ./hardcode-version.patch {
      inherit version;
    })

    # Fix importing debugpy in:
    # - test_nodebug[module-launch(externalTerminal)]
    # - test_nodebug[module-launch(integratedTerminal)]
    #
    # NOTE: The import failures seen in these tests without the patch
    # will be seen if a user "installs" debugpy by adding it to PYTHONPATH.
    # To avoid this issue, debugpy should be installed using python.withPackages:
    # python.withPackages (ps: with ps; [ debugpy ])
    ./fix-test-pythonpath.patch

    # Attach pid tests are disabled by default on windows & macos,
    # but are also flaky on linux:
    # - https://github.com/NixOS/nixpkgs/issues/262000
    # - https://github.com/NixOS/nixpkgs/issues/251045
    ./skip-attach-pid-tests.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Hard code GDB path (used to attach to process)
    (replaceVars ./hardcode-gdb.patch {
      inherit gdb;
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Hard code LLDB path (used to attach to process)
    (replaceVars ./hardcode-lldb.patch {
      inherit lldb;
    })
  ];

  # Compile attach library for host platform
  # Derived from linux_and_mac/compile_linux.sh & linux_and_mac/compile_mac.sh
  preBuild = ''
    (
        set -x
        cd src/debugpy/_vendored/pydevd/pydevd_attach_to_process
        $CXX linux_and_mac/attach.cpp -Ilinux_and_mac -std=c++11 -fPIC -nostartfiles ${
          {
            "x86_64-linux" = "-shared -o attach_linux_amd64.so";
            "i686-linux" = "-shared -o attach_linux_x86.so";
            "aarch64-linux" = "-shared -o attach_linux_arm64.so";
            "riscv64-linux" = "-shared -o attach_linux_riscv64.so";
            "x86_64-darwin" = "-D_REENTRANT -dynamiclib -lc -o attach.dylib";
            "aarch64-darwin" = "-D_REENTRANT -dynamiclib -lc -o attach.dylib";
          }
          .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
        }
      )'';

  build-system = [ setuptools ];

  # Disable tests for unmaintained versions of python
  doCheck = pythonAtLeast "3.11";

  nativeCheckInputs = [
    ## Used to run the tests:
    pytestCheckHook
    pytest-xdist
    pytest-timeout
    pytest-retry

    ## Used by test helpers:
    importlib-metadata
    psutil
    untangle

    ## Used in Python code that is run/debugged by the tests:
    django
    flask
    gevent
    numpy
    requests
    typing-extensions
  ];

  preCheck = ''
    export DEBUGPY_PROCESS_SPAWN_TIMEOUT=0
    export DEBUGPY_PROCESS_EXIT_TIMEOUT=0
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '';

  postCheck = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    unset no_proxy
  '';

  # Override default arguments in pytest.ini
  pytestFlags = [ "--timeout=0" ];

  disabledTests = [
    # hanging test (flaky)
    "test_systemexit"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # ConnectionResetError: [Errno 54] Connection reset by peer
    "tests/debugpy/test_breakpoints.py::test_error_in_condition[program-attach_connect(cli)-]"
    "tests/debugpy/test_breakpoints.py::test_error_in_condition[program-attach_connect(cli)-NameError]"
  ];

  # Fixes hanging tests on Darwin
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "debugpy" ];

  meta = {
    description = "Implementation of the Debug Adapter Protocol for Python";
    homepage = "https://github.com/microsoft/debugpy";
    changelog = "https://github.com/microsoft/debugpy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kira-bruneau ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "riscv64-linux"
    ];
  };
}
