{ basicsr
, buildPythonPackage
, cython
, facexlib
, fetchPypi
, lmdb
, numpy
, opencv-python
, pyyaml
, scipy
, torch
, torchvision
, tqdm
, yapf
, tensorboard
}:

buildPythonPackage rec {
  pname = "gfpgan";
  version = "1.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yf4c25grfb97y1mrdanp6d3mwh4400nnlnb902279lfrq38nq91";
  };

  buildInputs = [ cython numpy ];
  propagatedBuildInputs = [
    basicsr
    facexlib
    lmdb
    numpy
    opencv-python
    pyyaml
    scipy
    torch
    torchvision
    tqdm
    yapf
    tensorboard
  ];

  # TODO FIXME
  doCheck = false;

  meta = {
    description =
      "GFPGAN aims at developing Practical Algorithms for Real-world Face Restoration";
    homepage = "https://github.com/TencentARC/GFPGAN";
  };
}
