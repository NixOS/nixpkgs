{ lib
, buildPythonPackage
, fetchPypi
, decopatch
, makefun
, setuptools-scm
, pytest
, pytestCheckHook
, pytest-cases
, pandas
, tabulate
}:

buildPythonPackage rec {
  pname = "pytest-harvest";
  version = "1.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "+A1ylYw0lRHOtf+oolphZtHsarz93CNpBAjzG5ancSQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    decopatch
    makefun
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cases
    pandas
    tabulate
  ];

  pythonImportsCheck = [
    "pytest_harvest"
  ];

  postPatch = ''
    # Not actually needed?
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""

    # Defining 'pytest_plugins' in a non-top-level conftest is no longer supported.
    # https://github.com/smarie/python-pytest-harvest/pull/62
    mv pytest_harvest/tests/conftest.py .
  '';

  meta = with lib; {
    description = "Library for creating step-wise/incremental tests in pytest";
    homepage = "https://github.com/smarie/python-pytest-harvest";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
