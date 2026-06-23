{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  numpy,
  pandas,
  packaging,

  astropy,
  pytestCheckHook,
  pytest-doctestplus,
}:

buildPythonPackage rec {
  pname = "drms";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sunpy";
    repo = "drms";
    tag = "v${version}";
    hash = "sha256-Hd65bpJCknBeRd27JlcIkzzoZv5nGR7C6oMSGPFiyjA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    pandas
    packaging
  ];

  nativeCheckInputs = [
    astropy
    pytestCheckHook
    pytest-doctestplus
  ];

  disabledTests = [
    "test_query_hexadecimal_strings"
    "test_jsocinfoconstants" # Need network
  ];

  disabledTestPaths = [ "docs/tutorial.rst" ];

  pythonImportsCheck = [ "drms" ];

  meta = {
    description = "Access HMI, AIA and MDI data with Python";
    homepage = "https://github.com/sunpy/drms";
    changelog = "https://github.com/sunpy/drms/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
