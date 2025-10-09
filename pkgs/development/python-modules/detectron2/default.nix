{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ninja,
  which,

  # buildInputs
  pybind11,

  # dependencies
  black,
  cloudpickle,
  fvcore,
  hydra-core,
  iopath,
  matplotlib,
  omegaconf,
  packaging,
  pillow,
  pycocotools,
  pydot,
  tabulate,
  tensorboard,
  termcolor,
  torch,
  tqdm,
  yacs,

  # optional-dependencies
  fairscale,
  psutil,
  pygments,
  scipy,
  shapely,
  timm,

  # tests
  av,
  opencv4,
  pytest-mock,
  pytestCheckHook,
  torchvision,
}:

let
  pname = "detectron2";
  version = "0.6";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "detectron2";
    tag = "v${version}";
    hash = "sha256-TosuUZ1hJrXF3VGzsGO2hmQJitGUxe7FyZyKjNh+zPA=";
  };

  postPatch =
    # https://github.com/facebookresearch/detectron2/issues/5010
    ''
      substituteInPlace detectron2/data/transforms/transform.py \
        --replace-fail "interp=Image.LINEAR" "interp=Image.BILINEAR"
    '';

  nativeBuildInputs = [
    ninja
    which
  ];

  buildInputs = [ pybind11 ];

  pythonRelaxDeps = [
    "black"
    "iopath"
  ];

  pythonRemoveDeps = [
    "future"
  ];

  dependencies = [
    black
    cloudpickle
    fvcore
    hydra-core
    iopath
    matplotlib
    omegaconf
    packaging
    pillow
    pycocotools
    pydot # no idea why this is not in their setup.py
    tabulate
    tensorboard
    termcolor
    torch # not explicitly declared in setup.py because they expect you to install it yourself
    tqdm
    yacs
  ];

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

  nativeCheckInputs = [
    av
    opencv4
    pytest-mock
    pytestCheckHook
    torchvision
  ];

  preCheck =
    # prevent import errors for C extension modules
    ''
      rm -r detectron2
    '';

  enabledTestPaths = [
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

  disabledTests = [
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
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    "test_build_batch_dataloader_inference"
    "test_build_dataloader_inference"
    "test_build_iterable_dataloader_inference"
    "test_to_iterable"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: required keyword attribute 'value' has the wrong type
    "test_apply_deltas_tracing"
    "test_imagelist_padding_tracing"
    "test_roi_pooler_tracing"
  ];

  pythonImportsCheck = [ "detectron2" ];

  meta = {
    description = "Facebooks's next-generation platform for object detection, segmentation and other visual recognition tasks";
    homepage = "https://github.com/facebookresearch/detectron2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
