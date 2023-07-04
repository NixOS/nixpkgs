{ lib
, buildPythonPackage
, fetchPypi
, h5py
, numpy
, pandas
, pytestCheckHook
, pytest-mock
, pytest-remotedata
, pytest-rerunfailures
, pytest-timeout
, pytz
, requests
, requests-mock
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.10.0";
  format = "pyproject";

  src = fetchPypi{
    inherit pname version;
    hash = "sha256-K/f6tjBznXYJz+Y5tVS1Bj+DKcPtCPlwiKe/YTEsGSI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    h5py
    numpy
    pandas
    pytz
    requests
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-remotedata
    pytest-rerunfailures
    pytest-timeout
    requests-mock
  ];

  meta = with lib; {
    homepage = "https://pvlib-python.readthedocs.io";
    description = "Simulate the performance of photovoltaic energy systems";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
