{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, gdb
, colorama
, flask
, psutil
, pytest-timeout
, pytest_xdist
, pytestCheckHook
, requests
, isPy27
, django
, gevent
}:

buildPythonPackage rec {
  pname = "debugpy";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f6a62hg82fn9ddrl6g11x2h27zng8jmrlfbnnra6q590i5v1ixr";
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

  postPatch = ''
    # Use nixpkgs version instead of versioneer
    substituteInPlace setup.py \
      --replace "cmds = versioneer.get_cmdclass()" "cmds = {}" \
      --replace "version=versioneer.get_version()" "version='${version}'"
  '';

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
    colorama
    flask
    psutil
    pytest-timeout
    pytest_xdist
    pytestCheckHook
    requests
  ] ++ lib.optionals (!isPy27) [
    django
    gevent
  ];

  # Override default arguments in pytest.ini
  pytestFlagsArray = [ "--timeout=0" "-n=$NIX_BUILD_CORES" ];

  disabledTests = lib.optionals isPy27 [
    # django 1.11 is the last version to support Python 2.7
    # and is no longer built in nixpkgs
    "django"

    # gevent fails to import zope.interface with Python 2.7
    "gevent"
  ];

  meta = with lib; {
    description = "An implementation of the Debug Adapter Protocol for Python";
    homepage = "https://github.com/microsoft/debugpy";
    license = licenses.mit;
    maintainers = with maintainers; [ metadark ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "i686-darwin" ];
  };
}
