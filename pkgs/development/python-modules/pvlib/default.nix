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
  version = "0.10.1";
  format = "pyproject";

  src = fetchPypi{
    inherit pname version;
    hash = "sha256-H3wiNCmnZ6+GjXMhDbeOL98Yy7V6s2oOFAKWJCb8XCk=";
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
