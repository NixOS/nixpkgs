{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook
, ninja
# build inputs
, pillow
, matplotlib
, pycocotools
, termcolor
, yacs
, tabulate
, cloudpickle
, tqdm
, tensorboard
, fvcore
, iopath
, omegaconf
, hydra-core
, black
, packaging
# optional dependencies
, fairscale
, timm
, scipy
, shapely
, pygments
, psutil
}:

let
  name = "detectron2";
  version = "0.6";
  optional-dependencies = {
    all = [
      fairscale
      timm
      scipy
      shapely
      pygments
      psutil
    ];
  };
in
buildPythonPackage {
  inherit name version;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = name;
    rev = "v${version}";
    sha256 = "1w6cgvc8r2lwr72yxicls650jr46nriv1csivp2va9k1km8jx2sf";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    ninja
  ];

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  pythonRelaxDeps = [
    "black"
  ];

  propagatedBuildInputs = [
    pillow
    matplotlib
    pycocotools
    termcolor
    yacs
    tabulate
    cloudpickle
    tqdm
    tensorboard
    fvcore
    iopath
    omegaconf
    hydra-core
    black
    packaging
  ] ++ optional-dependencies.all;

  passthru.optional-dependencies = optional-dependencies;

  # disable the tests for now until someone can check on a linux machine.
  # doCheck = false;

  pythonImportsCheck = [ "detectron2" ];

  meta = with lib; {
    description = "Facebooks's next-generation platform for object detection, segmentation and other visual recognition tasks";
    homepage = "https://github.com/facebookresearch/detectron2";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
