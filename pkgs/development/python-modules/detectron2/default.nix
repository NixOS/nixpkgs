{ lib
, buildPythonPackage
, black
, cloudpickle
, cython
, fetchFromGitHub
, fetchPypi
, fvcore
, hydra-core
, matplotlib
, omegaconf
, pybind11
, pycocotools
, pydot
, pytest
, torch
, pyyaml
, tensorflow-tensorboard
, tqdm
, which
}:

buildPythonPackage rec {
  name = "detectron2";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = name;
    rev = "v${version}";
    sha256 = "1w6cgvc8r2lwr72yxicls650jr46nriv1csivp2va9k1km8jx2sf";
  };

  patchPhase = ''
    substituteInPlace setup.py --replace "black==21.4b2" "black>=21.4b2"
  '';

  nativeBuildInputs = [
    which
  ];

  propagatedBuildInputs = [
    black
    cython
    omegaconf
    pybind11
    pyyaml
    torch
    pydot
    tqdm
    cloudpickle
    fvcore
    matplotlib
    pycocotools
    tensorflow-tensorboard
    hydra-core
  ];

  doCheck = false;

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    description = "Facebooks's next-generation platform for object detection, segmentation and other visual recognition tasks";
    homepage = "https://github.com/facebookresearch/detectron2";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
