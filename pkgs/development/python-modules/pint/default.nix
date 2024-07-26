{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools
, setuptools-scm

# propagates
, typing-extensions

# tests
, pytestCheckHook
, pytest-subtests
, pytest-benchmark
, numpy
, matplotlib
, uncertainties
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.23";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "Pint";
    hash = "sha256-4VCbkWBtvFJSfGAKTvdP+sEv/3Boiv8g6QckCTRuybQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
    pytest-benchmark
    numpy
    matplotlib
    uncertainties
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # https://github.com/hgrecco/pint/issues/1898
    "test_load_definitions_stage_2"
  ];

  meta = with lib; {
    changelog = "https://github.com/hgrecco/pint/blob/${version}/CHANGES";
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = with maintainers; [ doronbehar ];
  };
}
