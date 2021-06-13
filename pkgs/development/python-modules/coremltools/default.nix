{ lib
, buildPythonPackage
, fetchPypi
, attrs
, numpy
, packaging
, protobuf
, scipy
, six
, sympy
, tqdm
, isPy38
, onnx
, pandas
, pillow
, pytestCheckHook
, pytorch
, scikitlearn
, torchvision
}:

buildPythonPackage rec {
  pname = "coremltools";
  version = "4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd652282431ba6b9b62744888138fb24289dcc0ef0811a8bb6ab85f9b4f6dffd";
  };

  propagatedBuildInputs = [
    attrs
    numpy
    packaging
    protobuf
    scipy
    six
    sympy
    tqdm
  ];

  # attr should not be there
  # the correct name is attrs (which is already in the list)
  prePatch = ''
    substituteInPlace setup.py \
      --replace '"attr",' ""
  '';

  # Python3.7 fails due to test failures related to pytorch
  # Python3.9 fails because boto fails to build
  doCheck = isPy38;

  checkInputs = [
    onnx
    pandas
    pillow
    pytestCheckHook
    pytorch
    scikitlearn
    torchvision
  ];

  # skip tests which require downloaded models or macOS
  disabledTests = [
    "test_convert_torch_vision_mobilenet_v2"
    "test_lrn_model"
    "test_nn_fp16_make_updatable_fail"
    "test_nn_partial_fp16_make_updatable_quantized_layer_fail"
    "test_no_inputs"
    "test_pixel_shuffle"
    "test_torch_enumerated_shapes"
  ];

  meta = with lib; {
    homepage = "https://coremltools.readme.io";
    description = "Community Tools for Core ML";
    license = licenses.bsd3;
    maintainers = with maintainers; [ prusnak ];
  };
}
