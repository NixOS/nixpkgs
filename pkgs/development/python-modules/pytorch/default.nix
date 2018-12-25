{ stdenv, fetchurl, buildPythonPackage, pythonOlder,
  cudaSupport ? false, cudatoolkit ? null, cudnn ? null,
  fetchFromGitHub, lib, numpy, pyyaml, cffi, typing, cmake, hypothesis, numactl,
  linkFarm, symlinkJoin,
  utillinux, which }:

assert cudnn == null || cudatoolkit != null;
assert !cudaSupport || cudatoolkit != null;

let
  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
  };

  # Normally libcuda.so.1 is provided at runtime by nvidia-x11 via
  # LD_LIBRARY_PATH=/run/opengl-driver/lib.  We only use the stub
  # libcuda.so from cudatoolkit for running tests, so that we don’t have
  # to recompile pytorch on every update to nvidia-x11 or the kernel.
  cudaStub = linkFarm "cuda-stub" [{
    name = "libcuda.so.1";
    path = "${cudatoolkit}/lib/stubs/libcuda.so";
  }];
  cudaStubEnv = lib.optionalString cudaSupport
    "LD_LIBRARY_PATH=${cudaStub}\${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} ";

in buildPythonPackage rec {
  version = "1.0.0";
  pname = "pytorch";

  src = fetchFromGitHub {
    owner  = "pytorch";
    repo   = "pytorch";
    rev    = "v${version}";
    fetchSubmodules = true;
    sha256 = "076cpbig4sywn9vv674c0xdg832sdrd5pk1d0725pjkm436kpvlm";
  };

  patches =
    [ # Skips two tests that are only meant to run on multi GPUs
      (fetchurl {
        url = "https://github.com/pytorch/pytorch/commit/bfa666eb0deebac21b03486e26642fd70d66e478.patch";
        sha256 = "1fgblcj02gjc0y62svwc5gnml879q3x2z7m69c9gax79dpr37s9i";
      })
    ];

  preConfigure = lib.optionalString cudaSupport ''
    export CC=${cudatoolkit.cc}/bin/gcc CXX=${cudatoolkit.cc}/bin/g++
  '' + lib.optionalString (cudaSupport && cudnn != null) ''
    export CUDNN_INCLUDE_DIR=${cudnn}/include
  '';

  preFixup = ''
    function join_by { local IFS="$1"; shift; echo "$*"; }
    function strip2 {
      IFS=':'
      read -ra RP <<< $(patchelf --print-rpath $1)
      IFS=' '
      RP_NEW=$(join_by : ''${RP[@]:2})
      patchelf --set-rpath \$ORIGIN:''${RP_NEW} "$1"
    }

    for f in $(find ''${out} -name 'libcaffe2*.so')
    do
      strip2 $f
    done
  '';

  # Override the (weirdly) wrong version set by default. See
  # https://github.com/NixOS/nixpkgs/pull/52437#issuecomment-449718038
  # https://github.com/pytorch/pytorch/blob/v1.0.0/setup.py#L267
  PYTORCH_BUILD_VERSION = version;
  PYTORCH_BUILD_NUMBER = 0;

  # Suppress a weird warning in mkl-dnn, part of ideep in pytorch
  # (upstream seems to have fixed this in the wrong place?)
  # https://github.com/intel/mkl-dnn/commit/8134d346cdb7fe1695a2aa55771071d455fae0bc
  NIX_CFLAGS_COMPILE = lib.optionals (numpy.blasImplementation == "mkl") [ "-Wno-error=array-bounds" ];

  buildInputs = [
     cmake
     numpy.blas
     utillinux
     which
  ] ++ lib.optionals cudaSupport [ cudatoolkit_joined cudnn ]
    ++ lib.optionals stdenv.isLinux [ numactl ];

  propagatedBuildInputs = [
    cffi
    numpy
    pyyaml
  ] ++ lib.optional (pythonOlder "3.5") typing;

  checkInputs = [ hypothesis ];
  checkPhase = ''
    ${cudaStubEnv}python test/run_test.py --exclude dataloader sparse torch utils thd_distributed distributed cpp_extensions
  '';

  meta = {
    description = "Open source, prototype-to-production deep learning platform";
    homepage    = https://pytorch.org/;
    license     = lib.licenses.bsd3;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ teh thoughtpolice ];
  };
}
