{ lib
, buildPythonPackage
, pytestCheckHook
, fetchFromGitHub
, python
, pythonOlder
, setuptools
, setuptools-scm
, numpy
, wheel
, hypothesis
, pytest-cov
}:

buildPythonPackage rec {
  pname = "fast-histogram";
  version = "0.12";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "astrofrog";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cz4BgbtxbUPxL2NSzvZYjbYIN4KUuliUV0bXRRtyvfM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pytest-cov
  ];

  pytestFlagsArray = [ "${builtins.placeholder "out"}/${python.sitePackages}" ];

  pythonImportsCheck = [ "fast_histogram" ];

  meta = with lib; {
    homepage = "https://github.com/astrofrog/fast-histogram";
    description = "Fast 1D and 2D histogram functions in Python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ifurther ];
  };
}
