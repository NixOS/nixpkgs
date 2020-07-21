{ stdenv, buildPythonPackage, fetchFromGitHub
, substituteAll, gdb
, colorama, django, flask, gevent, psutil, pytest
, pytest-timeout, pytest_xdist, requests
, isPy27
}:

buildPythonPackage rec {
  pname = "debugpy";
  version = "1.0.0b12";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sz33aq5qldl7kh4qjf5w3d08l9s77ipcj4i9wfklj8f6vf9w1wh";
  };

  patches = [
    # Hard code GDB path (used to attach to process)
    (substituteAll {
      src = ./hardcode-gdb.patch;
      inherit gdb;
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
      "x86_64-linux"  = "-shared -m64 -o attach_linux_amd64.so";
      "i686-linux"    = "-shared -m32 -o attach_linux_x86.so";
      "x86_64-darwin" = "-std=c++11 -lc -D_REENTRANT -dynamiclib -arch x86_64 -o attach_x86_64.dylib";
      "i686-darwin"   = "-std=c++11 -lc -D_REENTRANT -dynamiclib -arch i386 -o attach_x86.dylib";
    }.${stdenv.hostPlatform.system}}
  )'';

  checkInputs = [
    colorama django flask gevent psutil pytest
    pytest-timeout pytest_xdist requests
  ];

  # Override default arguments in pytest.ini
  checkPhase = "pytest --timeout 0 -n $NIX_BUILD_CORES"
               # gevent fails to import zope.interface with Python 2.7
               + stdenv.lib.optionalString isPy27 " -k 'not test_gevent'";

  meta = with stdenv.lib; {
    description = "An implementation of the Debug Adapter Protocol for Python";
    homepage = "https://github.com/microsoft/debugpy";
    license = licenses.mit;
    maintainers = with maintainers; [ metadark ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "i686-darwin" ];
  };
}
