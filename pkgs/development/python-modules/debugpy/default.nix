{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, gdb
, django
, flask
, gevent
, psutil
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, requests
, isPy3k
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "debugpy";
  version = "1.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dPP4stLt5nl9B9afPmH6/hpGKXBsaTpvYZQSHxU6KaY=";
  };

  patches = [
    # Hard code GDB path (used to attach to process)
    (substituteAll {
      src = ./hardcode-gdb.patch;
      inherit gdb;
    })

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
  ];

  # Remove pre-compiled "attach" libraries and recompile for host platform
  # Compile flags taken from linux_and_mac/compile_linux.sh & linux_and_mac/compile_mac.sh
  preBuild = ''(
    set -x
    cd src/debugpy/_vendored/pydevd/pydevd_attach_to_process
    rm *.so *.dylib *.dll *.exe *.pdb
    ${stdenv.cc}/bin/c++ linux_and_mac/attach.cpp -Ilinux_and_mac -fPIC -nostartfiles ${{
      "x86_64-linux"   = "-shared -m64 -o attach_linux_amd64.so";
      "i686-linux"     = "-shared -m32 -o attach_linux_x86.so";
      "aarch64-linux"  = "-shared -o attach_linux_arm64.so";
      "x86_64-darwin"  = "-std=c++11 -lc -D_REENTRANT -dynamiclib -arch x86_64 -o attach_x86_64.dylib";
      "i686-darwin"    = "-std=c++11 -lc -D_REENTRANT -dynamiclib -arch i386 -o attach_x86.dylib";
      "aarch64-darwin" = "-std=c++11 -lc -D_REENTRANT -dynamiclib -arch arm64 -o attach_arm64.dylib";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")}
  )'';

  doCheck = isPy3k;

  checkInputs = [
    django
    flask
    gevent
    psutil
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    requests
  ];

  # Override default arguments in pytest.ini
  pytestFlagsArray = [
    "--timeout=0"
    "-n=$NIX_BUILD_CORES"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    "test_flask_breakpoint_multiproc"
    "test_subprocess[program-launch-None]"
    "test_systemexit[0-zero-uncaught-raised-launch(integratedTerminal)-module]"
    "test_systemexit[0-zero-uncaught--attach_pid-program]"
    "test_success_exitcodes[-break_on_system_exit_zero-0-attach_listen(cli)-module]"
    "test_success_exitcodes[--0-attach_connect(api)-program]"
    "test_run[code-attach_connect(api)]"
    "test_subprocess[program-launch-None]"
  ];

  pythonImportsCheck = [
    "debugpy"
  ];

  meta = with lib; {
    description = "An implementation of the Debug Adapter Protocol for Python";
    homepage = "https://github.com/microsoft/debugpy";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "i686-darwin" "aarch64-darwin" ];
  };
}
