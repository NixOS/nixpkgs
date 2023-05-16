<<<<<<< HEAD
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
  version = "0.10.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi{
    inherit pname version;
    hash = "sha256-H3wiNCmnZ6+GjXMhDbeOL98Yy7V6s2oOFAKWJCb8XCk=";
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
=======
{ lib, buildPythonPackage, fetchPypi, fetchpatch, pythonOlder, numpy, pandas, pytz, six
, pytestCheckHook, flaky, mock, pytest-mock, requests }:

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.7.2";

  # Support for Python <3.5 dropped in 0.6.3 on June 1, 2019.
  disabled = pythonOlder "3.5";

  src = fetchPypi{
    inherit pname version;
    sha256 = "40708492ed0a41e900d36933b9b9ab7b575c72ebf3eee81293c626e301aa7ea1";
  };

  patches = [
    # enable later pandas versions, remove next bump
    (fetchpatch {
      url = "https://github.com/pvlib/pvlib-python/commit/010a2adc9e9ef6fe9f2aea4c02d7e6ede9f96a53.patch";
      sha256 = "0jibn4khixz6hv6racmp86m5mcms0ysz1y5bgpplw1kcvf8sn04x";
      excludes = [
        "pvlib/tests/test_inverter.py"
        "docs/sphinx/source/whatsnew/v0.8.0.rst"
        "ci/requirements-py35-min.yml"
      ];
    })
  ];

  nativeCheckInputs = [ pytestCheckHook flaky mock pytest-mock ];
  propagatedBuildInputs = [ numpy pandas pytz six requests ];

  # Skip a few tests that try to access some URLs
  pytestFlagsArray = [ "pvlib/tests" ];
  disabledTests = [
    "read_srml_dt_index"
    "read_srml_month_from_solardata"
    "get_psm3"
    "pvgis"
    "read_surfrad_network"
    "remote"
    # small rounding errors, E.g <1e-10^5
    "calcparams_pvsyst"
    "martin_ruiz_diffuse"
    "hsu"
    "backtrack"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    homepage = "https://pvlib-python.readthedocs.io";
    description = "Simulate the performance of photovoltaic energy systems";
<<<<<<< HEAD
    changelog = "https://pvlib-python.readthedocs.io/en/v${version}/whatsnew.html";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
