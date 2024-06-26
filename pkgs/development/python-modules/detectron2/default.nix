{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  ninja,
  which,
  # build inputs
  pillow,
  matplotlib,
  pycocotools,
  termcolor,
  yacs,
  tabulate,
  cloudpickle,
  tqdm,
  tensorboard,
  fvcore,
  iopath,
  omegaconf,
  hydra-core,
  packaging,
  torch,
  pydot,
  black,
  # optional dependencies
  fairscale,
  timm,
  scipy,
  shapely,
  pygments,
  psutil,
  # check inputs
  pytestCheckHook,
  torchvision,
  av,
  opencv4,
  pytest-mock,
  pybind11,
}:

let
  pname = "detectron2";
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
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "detectron2";
    rev = "refs/tags/v${version}";
    sha256 = "1w6cgvc8r2lwr72yxicls650jr46nriv1csivp2va9k1km8jx2sf";
  };

  postPatch = ''
    # https://github.com/facebookresearch/detectron2/issues/5010
    substituteInPlace detectron2/data/transforms/transform.py \
      --replace "interp=Image.LINEAR" "interp=Image.BILINEAR"
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
    ninja
    which
  ];

  buildInputs = [ pybind11 ];

  pythonRelaxDeps = [ "black" ];

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
    packaging
    black
    torch # not explicitly declared in setup.py because they expect you to install it yourself
    pydot # no idea why this is not in their setup.py
  ];

  passthru.optional-dependencies = optional-dependencies;

  nativeCheckInputs = [
    av
    opencv4
    pytest-mock
    pytestCheckHook
    torchvision
  ];

  preCheck = ''
    # prevent import errors for C extension modules
    rm -r detectron2
  '';

  pytestFlagsArray = [
    # prevent include $sourceRoot/projects/*/tests
    "tests"
  ];

  disabledTestPaths = [
    # try import caffe2
    "tests/test_export_torchscript.py"
    "tests/test_model_analysis.py"
    "tests/modeling/test_backbone.py"
    "tests/modeling/test_roi_heads.py"
    "tests/modeling/test_rpn.py"
    "tests/structures/test_instances.py"
    # hangs for some reason
    "tests/modeling/test_model_e2e.py"
    # KeyError: 'precision'
    "tests/data/test_coco_evaluation.py"
  ];

  disabledTests =
    [
      # fails for some reason
      "test_checkpoint_resume"
      "test_map_style"
      # requires shapely
      "test_resize_and_crop"
      # require caffe2
      "test_predict_boxes_tracing"
      "test_predict_probs_tracing"
      "testMaskRCNN"
      "testRetinaNet"
      # require coco dataset
      "test_default_trainer"
      "test_unknown_category"
      "test_build_dataloader_train"
      "test_build_iterable_dataloader_train"
      # require network access
      "test_opencv_exif_orientation"
      "test_read_exif_orientation"
      # use deprecated api, numpy.bool
      "test_BWmode_nomask"
      "test_draw_binary_mask"
      "test_draw_empty_mask_predictions"
      "test_draw_instance_predictions"
      "test_draw_no_metadata"
      "test_overlay_instances"
      "test_overlay_instances_no_boxes"
      "test_get_bounding_box"
    ]
    ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
      "test_build_batch_dataloader_inference"
      "test_build_dataloader_inference"
      "test_build_iterable_dataloader_inference"
      "test_to_iterable"
    ];

  pythonImportsCheck = [ "detectron2" ];

  meta = with lib; {
    description = "Facebooks's next-generation platform for object detection, segmentation and other visual recognition tasks";
    homepage = "https://github.com/facebookresearch/detectron2";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
