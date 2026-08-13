{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytest-cov-stub,
  cython,
  setuptools,
  setuptools-scm,
  wheel,
  numpy,
  scipy,
  matplotlib,
  networkx,
  nibabel,
}:

buildPythonPackage rec {
  pname = "nitime";
  version = "0.12.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Esv0iLBlXcBaoYoMpZgt6XAwJgTkYfyS6H69m3U5tv8=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    networkx
    nibabel
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  doCheck = !stdenv.hostPlatform.isDarwin; # tests hang indefinitely

  disabledTests = [
    # [doctest] nitime.tests.test_timeseries.test_UniformTime_repr
    # Expected:
    #     UniformTime([    0.,  1000.,  2000.,  3000.,  4000.], time_unit='ms')
    # Got:
    #     UniformTime([   0., 1000., 2000., 3000., 4000.], time_unit='ms')
    "test_UniformTime_repr"
  ];

  pythonImportsCheck = [ "nitime" ];

  meta = {
    homepage = "https://nipy.org/nitime";
    description = "Algorithms and containers for time-series analysis in time and spectral domains";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
