{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, oldest-supported-numpy
, setuptools
, wheel
, scipy
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dtw-python";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "DynamicTimeWarping";
    repo = "dtw-python";
    rev = "v${version}";
    hash = "sha256-7hQuo7dES9f08YZhCf+kxUkMlrr+bg1P7HHRCMv3bLk=";
  };

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    scipy
    numpy
  ];

  # We need to run tests on real built package: https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = "cd $out";
  nativeCheckInputs = [ pytestCheckHook ];
  # tests/ are not included to output package, so we have to set path explicitly
  pytestFlagsArray = [
    "$src/tests"
  ];

  pythonImportsCheck = [ "dtw" ];

  meta = with lib; {
    description = "Python port of R's Comprehensive Dynamic Time Warp algorithms package";
    homepage = "https://github.com/DynamicTimeWarping/dtw-python";
    changelog = "https://github.com/DynamicTimeWarping/dtw-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
