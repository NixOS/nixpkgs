{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, importlib-metadata
, packaging
# Check Inputs
, pytestCheckHook
, pytest-subtests
, numpy
, matplotlib
, uncertainties
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.20.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "Pint";
    sha256 = "sha256-OHzwQHjcff5KcIAzuq1Uq2HYKrBsTuPUkiseRdViYGc=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ packaging ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
    numpy
    matplotlib
    uncertainties
  ];

  dontUseSetuptoolsCheck = true;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = with maintainers; [ costrouc doronbehar ];
  };
}
