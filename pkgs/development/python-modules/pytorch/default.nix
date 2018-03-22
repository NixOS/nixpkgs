{ buildPythonPackage, fetchFromGitHub, lib, numpy, pyyaml, cffi, cmake,
  git, stdenv }:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "pytorch";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "pytorch";
    repo   = "pytorch";
    rev    = "v${version}";
    sha256 = "1s3f46ga1f4lfrcj3lpvvhgkdr1pi8i2hjd9xj9qiz3a9vh2sj4n";
  };

  checkPhase = ''
    ${stdenv.shell} test/run_test.sh
  '';

  buildInputs = [
     cmake
     git
     numpy.blas
  ];

  propagatedBuildInputs = [
    cffi
    numpy
    pyyaml
  ];

  preConfigure = ''
    export NO_CUDA=1
  '';

  meta = {
    description = "Tensors and Dynamic neural networks in Python with strong GPU acceleration.";
    homepage = http://pytorch.org/;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ teh ];
  };
}
