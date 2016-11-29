{ buildPythonPackage
, fetchFromGitHub
, numpy
, six
, scipy
, nose
, nose-parameterized
, pydot_ng
, sphinx
, pygments
, libgpuarray
, python
, pycuda
, cudatoolkit
, cudnn
, stdenv
}:

buildPythonPackage rec {
  name = "Theano-CUDA-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Theano";
    repo = "Theano";
    rev = "cdac0c69c24cf730eb6689037f9c41bdf1c43686";
    sha256 = "1wi2sx8kr1jqj15k7w1bmb3hrjkkfgyp2iwqy5q3mqz15k5k377f";
  };

  doCheck = false;
  dontStrip = true;

  propagatedBuildInputs = [
    numpy.blas
    numpy
    six
    scipy
    nose
    nose-parameterized
    pydot_ng
    sphinx
    pygments
    pycuda
    cudatoolkit
    libgpuarray
  ] ++ (stdenv.lib.optional (cudnn != null) [ cudnn ]);

  passthru.cudaSupport = true;
}
