{ buildPythonPackage, pythonOlder,
  cudaSupport ? false, cudatoolkit ? null, cudnn ? null,
  fetchFromGitHub, fetchpatch, lib, numpy, pyyaml, cffi, typing, cmake,
  stdenv, linkFarm, symlinkJoin,
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
  version = "0.4.0";
  pname = "pytorch";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "pytorch";
    repo   = "pytorch";
    rev    = "v${version}";
    fetchSubmodules = true;
    sha256 = "12d5vqqaprk0igmih7fwa65ldmaawgijxl58h6dnw660wysc132j";
  };

  preConfigure = lib.optionalString cudaSupport ''
    export CC=${cudatoolkit.cc}/bin/gcc CXX=${cudatoolkit.cc}/bin/g++
  '' + lib.optionalString (cudaSupport && cudnn != null) ''
    export CUDNN_INCLUDE_DIR=${cudnn}/include
  '';

  buildInputs = [
     cmake
     numpy.blas
     utillinux
     which
  ] ++ lib.optionals cudaSupport [cudatoolkit_joined cudnn];

  propagatedBuildInputs = [
    cffi
    numpy
    pyyaml
  ] ++ lib.optional (pythonOlder "3.5") typing;

  checkPhase = ''
    ${cudaStubEnv}python test/run_test.py --exclude distributed
  '';

  meta = {
    description = "Tensors and Dynamic neural networks in Python with strong GPU acceleration.";
    homepage = http://pytorch.org/;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ teh ];
  };
}
