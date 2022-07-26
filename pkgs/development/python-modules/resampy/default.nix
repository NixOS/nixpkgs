{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, numba
, numpy
, pytestCheckHook
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "resampy";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bmcfee";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kqRWW50VQO8H02vHgbdHo578c2jXX4fgF8AY6JuQOSI=";
  };

  propagatedBuildInputs = [
    numpy
    cython
    numba
  ];

  checkInputs = [
    pytestCheckHook
    scipy
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov-report term-missing --cov resampy --cov-report=xml" ""
  '';

  pythonImportsCheck = [
    "resampy"
  ];

  meta = with lib; {
    description = "Efficient signal resampling";
    homepage = "https://github.com/bmcfee/resampy";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
  };
}
