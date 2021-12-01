{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, substituteAll
, fetchpatch
, gdb
, django
, flask
, gevent
, psutil
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "debugpy";
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jcokiAZ2WwyIvsXNIUzvMIrRttR76RwDSE7gk0xHExc=";
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

    # Fix compiling attach library from source
    # https://github.com/microsoft/debugpy/pull/978
    (fetchpatch {
      url = "https://github.com/microsoft/debugpy/commit/08b3b13cba9035f4ab3308153aef26e3cc9275f9.patch";
      sha256 = "sha256-8E+Y40mYQou9T1ozWslEK2XNQtuy5+MBvPvDLt4eQak=";
    })
  ];

  # Remove pre-compiled "attach" libraries and recompile for host platform
  # Compile flags taken from linux_and_mac/compile_linux.sh & linux_and_mac/compile_mac.sh
  preBuild = ''(
    set -x
    cd src/debugpy/_vendored/pydevd/pydevd_attach_to_process
    rm *.so *.dylib *.dll *.exe *.pdb
    ${stdenv.cc}/bin/c++ linux_and_mac/attach.cpp -Ilinux_and_mac -fPIC -nostartfiles ${{
      "x86_64-linux"   = "-shared -o attach_linux_amd64.so";
      "i686-linux"     = "-shared -o attach_linux_x86.so";
      "aarch64-linux"  = "-shared -o attach_linux_arm64.so";
      "x86_64-darwin"  = "-std=c++11 -lc -D_REENTRANT -dynamiclib -o attach_x86_64.dylib";
      "i686-darwin"    = "-std=c++11 -lc -D_REENTRANT -dynamiclib -o attach_x86.dylib";
      "aarch64-darwin" = "-std=c++11 -lc -D_REENTRANT -dynamiclib -o attach_arm64.dylib";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")}
  )'';

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
  ];

  # Fixes hanging tests on Darwin
  __darwinAllowLocalNetworking = true;

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
