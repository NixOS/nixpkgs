{
  lib,
  fetchurl,
  fetchFromGitHub,
  buildPythonPackage,
  python,

  # build-system
  setuptools,

  # dependencies
  otb,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  requests,
  writableTmpDirAsHomeHook,
}:
let
  # fetch the test data separately or else none of the test will work
  # https://github.com/orfeotoolbox/pyotb/blob/develop/tests/tests_data.py
  spotImage = fetchurl {
    url = "https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/raw/develop/Data/Input/SP67_FR_subset_1.tif";
    sha256 = "sha256-MuWY/g7KI+F23lFY/+AX5MLWJlIgHCr5BvFjDHzpWgY=";
  };

  pleiadesImage = fetchurl {
    url = "https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/raw/develop/Data/Baseline/OTB/Images/prTvOrthoRectification_pleiades-1_noDEM.tif";
    sha256 = "sha256-1EsGAJdHgBIb/gfbh4Y7yEEmYHb54bSx4fEMKssZ/oA=";
  };

  otbWithPy = otb.override {
    enablePython = true;
    python3 = python;
  };
in
buildPythonPackage rec {
  pname = "pyotb";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "orfeotoolbox";
    repo = "pyotb";
    tag = version;
    hash = "sha256-KomIMVx4jfsTSbGtoml9ON/82sHanOkp/mp1TiUaa2E=";
  };

  postPatch = ''
    substituteInPlace pyotb/helpers.py \
      --replace-fail 'OTB_ROOT = os.environ.get("OTB_ROOT")' 'OTB_ROOT = "${otbWithPy}"' \
      --replace-fail 'os.environ["GDAL_DATA"] = gdal_data' "" \
      --replace-fail 'os.environ["PROJ_LIB"] = proj_lib' "" \
      --replace-fail 'os.environ["GDAL_DRIVER_PATH"] = "disable"' ""

    ln -s ${spotImage} $HOME/SP67_FR_subset_1.tif
    ln -s ${pleiadesImage} $HOME/prTvOrthoRectification_pleiades-1_noDEM.tif

    substituteInPlace tests/tests_data.py \
      --replace-fail \
        'SPOT_IMG_URL = "https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/raw/develop/Data/Input/SP67_FR_subset_1.tif"' \
        "SPOT_IMG_URL = '$HOME/SP67_FR_subset_1.tif'" \
      --replace-fail \
        'PLEIADES_IMG_URL = "https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/raw/develop/Data/Baseline/OTB/Images/prTvOrthoRectification_pleiades-1_noDEM.tif"' \
        "PLEIADES_IMG_URL = '$HOME/prTvOrthoRectification_pleiades-1_noDEM.tif'"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [ otbWithPy ];

  pythonImportsCheck = [ "pyotb" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    requests
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # test requires network access as inputs needs to be url
    "test_app_input_vsi"
    "test_img_metadata"
    "test_summarize_pipeline_simple"
    "test_summarize_pipeline_diamond"
    "test_summarize_strip_output"
  ];

  meta = {
    description = "Python extension of Orfeo Toolbox";
    homepage = "https://github.com/orfeotoolbox/pyotb";
    changelog = "https://github.com/orfeotoolbox/pyotb/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
