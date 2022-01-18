{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, nose
, nbformat
, nbconvert
, jupyter
, chainer
, pytorch
, mxnet
, tensorflow
, keras
}:

buildPythonPackage rec {
  pname = "einops";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "arogozhnikov";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ix094cfh6w4bvx6ymp5dpm35y9nkaibcn1y50g6kwdp4f0473y8";
  };

  checkInputs = [
    nose
    numpy
    # For notebook tests
    nbformat
    nbconvert
    jupyter
    # For backend tests
    chainer
    pytorch
    mxnet
    tensorflow
    keras
  ];

  # No CUDA in sandbox
  EINOPS_SKIP_CUPY = 1;

  checkPhase = ''
    export HOME=$TMPDIR

    # Prevent hangs on PyTorch-related tests, see
    # https://discuss.pytorch.org/t/pytorch-cpu-hangs-on-nn-linear/17748/4
    export OMP_NUM_THREADS=1

    nosetests -v -w tests
  '';

  meta = {
    description = "Flexible and powerful tensor operations for readable and reliable code";
    homepage = "https://github.com/arogozhnikov/einops";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
