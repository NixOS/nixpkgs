{ lib
, buildPythonPackage
, fetchPypi
, makefun
, wrapt
, setuptools-scm
, pytest
, pytestCheckHook
, pytest-cases
, pytest-harvest
, pandas
, tabulate
}:

buildPythonPackage rec {
  pname = "pytest-steps";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hDfvTS9o8MY3RDRdkqQ3ttdlFuHNMP1kUqHFA5kIhc=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    makefun
    wrapt
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cases
    pytest-harvest
    pandas
    tabulate
  ];

  pythonImportsCheck = [
    "pytest_steps"
  ];

  postPatch = ''
    # Not actually needed?
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""

    # Defining 'pytest_plugins' in a non-top-level conftest is no longer supported.
    # https://github.com/smarie/python-pytest-steps/pull/54
    mv pytest_steps/tests/conftest.py .
  '';

  meta = with lib; {
    description = "Library for creating step-wise/incremental tests in pytest";
    homepage = "https://github.com/smarie/python-pytest-steps";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
