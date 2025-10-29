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

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.13.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qT/RGNBIt4fbZsI0SGwFwMZc8J2zRNggg5YbyCat9G8=";
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

  meta = with lib; {
    description = "Simulate the performance of photovoltaic energy systems";
    homepage = "https://pvlib-python.readthedocs.io";
    changelog = "https://pvlib-python.readthedocs.io/en/v${version}/whatsnew.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
