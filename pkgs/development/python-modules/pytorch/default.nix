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
    sha256 = "112mp3r70d8f15dhxm6k7912b5i6c2q8hv9462s808y84grr2jdm";
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
