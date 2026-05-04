{
  lib,
  buildPythonPackage,
  fetchPypi,
  h5py,
  numpy,
  pandas,
  pytestCheckHook,
  pytest-mock,
  pytest-remotedata,
  pytest-rerunfailures,
  pytest-timeout,
  pytz,
  requests,
  requests-mock,
  scipy,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pvlib";
  version = "0.15.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uIJKoo/UtwF5sxiI/EvJycF+HJn/Fxo/7F7cU/k0e80=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    h5py
    numpy
    pandas
    pytz
    requests
    scipy
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-remotedata
    pytest-rerunfailures
    pytest-timeout
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "pvlib" ];

  meta = {
    description = "Simulate the performance of photovoltaic energy systems";
    homepage = "https://pvlib-python.readthedocs.io";
    changelog = "https://pvlib-python.readthedocs.io/en/v${finalAttrs.version}/whatsnew.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jluttine ];
  };
})
