{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # buildInputs
  eccodes,

  # dependencies
  packaging,
  pyproj,

  # tests
  cartopy,
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygrib";
  version = "2.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jswhit";
    repo = "pygrib";
    tag = "v${finalAttrs.version}rel";
    hash = "sha256-29Z81JbQgsmkmtEhf+udcnRrv3wS87Wuk3VK1EUKgSY=";
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  buildInputs = [
    eccodes
  ];

  dependencies = [
    numpy
    packaging
    pyproj
  ];

  pythonImportsCheck = [ "pygrib" ];

  nativeCheckInputs = [
    cartopy
    matplotlib
    pytestCheckHook
  ];

  # Tests look for test data in ../sampledata
  preCheck = ''
    cd test
  '';

  disabledTestPaths = [
    # Require unpackaged pyspharm
    "test_spectral.py"

    # SyntaxError: source code string cannot contain null bytes
    "baseline_images/test_reduced_gg.py"
  ];

  meta = {
    description = "Python interface for reading and writing GRIB data";
    homepage = "https://github.com/jswhit/pygrib";
    changelog = "https://github.com/jswhit/pygrib/blob/${finalAttrs.src.tag}/Changelog";
    license = with lib.licenses; [
      asl20
      bsd2
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
