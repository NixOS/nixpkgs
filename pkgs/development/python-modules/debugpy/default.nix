{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  fetchFromGitHub,
  substituteAll,
  gdb,
  lldb,
  pytestCheckHook,
  pytest-xdist,
  pytest-timeout,
  importlib-metadata,
  psutil,
  django,
  requests,
  gevent,
  numpy,
  flask,
}:

buildPythonPackage rec {
  pname = "debugpy";
  version = "1.8.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "debugpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-kkFNIJ3QwojwgiRAOmBiWIg5desxOKTmo9YH1Qup6fI=";
  };

  patches =
    [
      # Use nixpkgs version instead of versioneer
      (substituteAll {
        src = ./hardcode-version.patch;
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
      (substituteAll {
        src = ./hardcode-gdb.patch;
        inherit gdb;
      })
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Hard code LLDB path (used to attach to process)
      (substituteAll {
        src = ./hardcode-lldb.patch;
        inherit lldb;
      })
    ];

  # Remove pre-compiled "attach" libraries and recompile for host platform
  # Compile flags taken from linux_and_mac/compile_linux.sh & linux_and_mac/compile_mac.sh
  preBuild = ''
    (
        set -x
        cd src/debugpy/_vendored/pydevd/pydevd_attach_to_process
        rm *.so *.dylib *.dll *.exe *.pdb
        $CXX linux_and_mac/attach.cpp -Ilinux_and_mac -std=c++11 -fPIC -nostartfiles ${
          {
            "x86_64-linux" = "-shared -o attach_linux_amd64.so";
            "i686-linux" = "-shared -o attach_linux_x86.so";
            "aarch64-linux" = "-shared -o attach_linux_arm64.so";
            "x86_64-darwin" = "-D_REENTRANT -dynamiclib -lc -o attach_x86_64.dylib";
            "i686-darwin" = "-D_REENTRANT -dynamiclib -lc -o attach_x86.dylib";
            "aarch64-darwin" = "-D_REENTRANT -dynamiclib -lc -o attach_arm64.dylib";
          }
          .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
        }
      )'';

  # Disable tests for unmaintained versions of python
  doCheck = pythonAtLeast "3.11";

  nativeCheckInputs = [
    ## Used to run the tests:
    pytestCheckHook
    pytest-xdist
    pytest-timeout

    ## Used by test helpers:
    importlib-metadata
    psutil

    ## Used in Python code that is run/debugged by the tests:
    django
    flask
    gevent
    numpy
    requests
  ];

  preCheck =
    ''
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
  pytestFlagsArray = [ "--timeout=0" ];

  # Fixes hanging tests on Darwin
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "debugpy" ];

  meta = with lib; {
    description = "Implementation of the Debug Adapter Protocol for Python";
    homepage = "https://github.com/microsoft/debugpy";
    changelog = "https://github.com/microsoft/debugpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "i686-darwin"
      "aarch64-darwin"
    ];
  };
}
