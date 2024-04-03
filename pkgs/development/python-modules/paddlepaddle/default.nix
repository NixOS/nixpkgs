{ stdenv
, config
, lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, pythonAtLeast
, zlib
, setuptools
, cudaSupport ? config.cudaSupport or false
, cudaPackages_11 ? {}
# , addOpenGLRunpath
# runtime dependencies
, httpx
, numpy
, protobuf
, pillow
, decorator
, astor
, paddle-bfloat
, opt-einsum
, cmake
, fetchFromGitHub
, pip
, wheel
, pyyaml
, jinja2
, liblapack
, openblas
, perl
, symlinkJoin
, writeScriptBin

, ccacheStdenv
}:

let
  version = "2.6.1";
  src = fetchFromGitHub ({
    owner = "PaddlePaddle";
    repo = "Paddle";
    rev = "v${version}";
    hash = "sha256-En+cGjExAbTrEJupOuyfPlEZq7MXTYJli6oKQqCBkfo=";
    # leaveDotGit = true;
    fetchSubmodules = true;
  });

  # The Paddle build process uses git to checkout in the submodules, which doesn't work.
  # However, the submodules already have the right commits so we just use a dummy git command.
  fakeGit = writeScriptBin "git" ''
    echo fakegit "$@"
    if [ "$1" = "rev-parse" ]; then
        exit 1
    fi
  '';

  # We build the C++ part in a separate derivation. This is so that when packaging we can iterate on CMake and Python
  # separately, because the C++ part takes a long time. Also, this way we get the Nix CMake settings automatically.
  paddlePaddleCmake = stdenv.mkDerivation {
    name = "paddlepaddle-cmake";
    inherit src;

    patches = [
      # Paddle wants to download and use precompiled lapack. This is unneccessary because
      # OpenBLAS provides LAPACK.
      ./no-extern-lapack.patch
    ];

    buildInputs = [ openblas ];
    nativeBuildInputs = [
      cmake
      pip
      wheel
      pyyaml
      jinja2
      perl

      numpy
      protobuf

      pip # pip won't actually work but configuration fails without it.

      fakeGit
    ];

    # Use OpenBLAS from nixpkgs. cblas.cmake expects /include and /lib to be in the same directory.
    OPENBLAS_ROOT = symlinkJoin {
      name = "openblas-merged";
      paths = [ openblas.out openblas.dev ];
    };

    cmakeFlags = [
      "-DWITH_MKL=OFF" # MKL support currently wants to download more sources, so disable for now.
      "-DWITH_SETUP_INSTALL=ON" # run as if called by setup.py, we'll call it ourselves after
    ];


    hardeningDisable = [ "fortify" ];
    enableParallelBuilding = true;

    # We just want the CMake build directory.
    installPhase = ''
      mkdir $out
      cp -r . $out/build
    '';

    # # Nix doesn't like rpaths to the build directory in the output, but we want to just copy it to another build, so turn this check off.
    noAuditTmpdir = true;

    # dontFixup = true;
    dontStrip = true;
  };
in
buildPythonPackage {
  pname = "paddlepaddle" + lib.optionalString cudaSupport "-gpu";
  format = "setuptools";
  inherit version src;

  PY_VERSION = python.pythonVersion;

  dontUseCmakeConfigure = true; # setup.py will call cmake itself.

  nativeBuildInputs = [
    cmake
    pip
    pyyaml
  ];

  propagatedBuildInputs = [
    numpy
    protobuf
    httpx
    pillow
    decorator
    astor
    paddle-bfloat
    opt-einsum
  ];

  patches = [
    ./no-python-cmake.patch
 ];

  # Copy the pre-built CMake directory.
  preBuild = ''
    echo Copying ${paddlePaddleCmake}
    cp -r --no-preserve=mode,ownership ${paddlePaddleCmake}/build .
  '';
#
  meta = with lib; {
    description = "PArallel Distributed Deep LEarning: Machine Learning Framework from Industrial Practice （『飞桨』核心框架，深度学习&机器学习高性能单机、分布式训练和跨平台部署";
    homepage = "https://github.com/PaddlePaddle/Paddle";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "x86_64-linux" ] ++ optionals (!cudaSupport) [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
