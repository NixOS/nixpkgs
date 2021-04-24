{ lib
, buildPythonPackage
, cloudpickle
, cython
, fetchFromGitHub
, fvcore
, matplotlib
, pycocotools
, pydot
, pytest
, pytestrunner
, pytorch
, pyyaml
, tensorflow-tensorboard
, tqdm
, which
}:

buildPythonPackage rec {
  name = "detectron2";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "detectron2";
    rev = "v${version}";
    sha256 = "0icy7pxgj83bir26z6qfb3wxas45jii4agldwf70my2fngp23qpj";
  };

  nativeBuildInputs = [
    which
  ];

  propagatedBuildInputs = [
    cython
    pyyaml
    pytorch
    pydot
    tqdm
    cloudpickle
    fvcore
    matplotlib
    pycocotools
    tensorflow-tensorboard
  ];

  doCheck = false;

  checkInputs = [
    pytest
    pytestrunner
  ];

  meta = with lib; {
    description = "Facebooks's next-generation platform for object detection, segmentation and other visual recognition tasks";
    homepage = "https://github.com/facebookresearch/detectron2";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
