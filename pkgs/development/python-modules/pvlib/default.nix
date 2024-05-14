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
, pythonOlder
, pytz
, requests
, requests-mock
, scipy
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.10.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi{
    inherit pname version;
    hash = "sha256-I+y59o4L+wLOF+hARLUh+341NYHlOKMfnq0ETs0ZUL0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
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

  pythonImportsCheck = [
    "pvlib"
  ];

  meta = with lib; {
    homepage = "https://pvlib-python.readthedocs.io";
    description = "Simulate the performance of photovoltaic energy systems";
    changelog = "https://pvlib-python.readthedocs.io/en/v${version}/whatsnew.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
