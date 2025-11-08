{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  scipy,
}:

buildPythonPackage rec {
  pname = "dmsuite";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IqLsHkGNgPz2yZm0QMyMMo6Mr2RsU2DPGxYpoNwC3fs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Slight precision error probably due to different BLAS backend on Darwin
  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    "test_cheb_scaled"
  ];

  pythonImportsCheck = [ "dmsuite" ];

  meta = {
    description = "Scientific library providing a collection of spectral collocation differentiation matrices";
    homepage = "https://github.com/labrosse/dmsuite";
    changelog = "https://github.com/labrosse/dmsuite/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
}
