{ buildPythonPackage,
  cudaSupport ? false, cudatoolkit ? null, cudnn ? null,
  fetchFromGitHub, lib, numpy, pyyaml, cffi, cmake,
  git, stdenv, symlinkJoin,
  utillinux, which }:

assert cudnn == null || cudatoolkit != null;
assert !cudaSupport || cudatoolkit != null;

let
  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
  };

in buildPythonPackage rec {
  version = "0.3.1";
  pname = "pytorch";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "pytorch";
    repo   = "pytorch";
    rev    = "v${version}";
    fetchSubmodules = true;
    sha256 = "1k8fr97v5pf7rni5cr2pi21ixc3pdj3h3lkz28njbjbgkndh7mr3";
  };

  preConfigure = lib.optionalString cudaSupport ''
    export CC=${cudatoolkit.cc}/bin/gcc
  '' + lib.optionalString (cudaSupport && cudnn != null) ''
    export CUDNN_INCLUDE_DIR=${cudnn}/include
  '';

  buildInputs = [
     cmake
     git
     numpy.blas
     utillinux
     which
  ] ++ lib.optionals cudaSupport [cudatoolkit_joined cudnn];

  propagatedBuildInputs = [
    cffi
    numpy
    pyyaml
  ];

  checkPhase = ''
    ${stdenv.shell} test/run_test.sh
  '';

  doCheck = !cudaSupport; # for some unknown reason doesn't detect cuda if run from builder user

  meta = {
    description = "Tensors and Dynamic neural networks in Python with strong GPU acceleration.";
    homepage = http://pytorch.org/;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ teh ];
  };
}
