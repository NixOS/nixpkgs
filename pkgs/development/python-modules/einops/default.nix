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
  ];

  # No CUDA in sandbox
  EINOPS_SKIP_CUPY = 1;

  checkPhase = ''
    export HOME=$TMPDIR
    nosetests -v -w tests
  '';

  meta = {
    description = "Flexible and powerful tensor operations for readable and reliable code";
    homepage = "https://github.com/arogozhnikov/einops";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
