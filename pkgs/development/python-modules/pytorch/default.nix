{ buildPythonPackage,
  cudaSupport ? false, cudatoolkit ? null, cudnn ? null,
  fetchFromGitHub, lib, numpy, pyyaml, cffi, cmake,
  git, stdenv,
  utillinux, which }:

assert cudnn == null || cudatoolkit != null;
assert !cudaSupport || cudatoolkit != null;

buildPythonPackage rec {
  version = "0.3.0";
  pname = "pytorch";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "pytorch";
    repo   = "pytorch";
    rev    = "af3964a8725236c78ce969b827fdeee1c5c54110";
    fetchSubmodules = true;
    sha256 = "0zbndardq3fpvxfa9qamkms0x7kxla4657lccrpyymydn97n888a";
  };

  preConfigure = lib.optionalString (cudnn != null) "export CUDNN_INCLUDE_DIR=${cudnn}/include";

  buildInputs = [
     cmake
     git
     numpy.blas
     utillinux
     which
  ] ++ lib.optionals cudaSupport [cudatoolkit cudnn];

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
