{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, ruamel-yaml
, attrs
, pythonOlder
, pytestCheckHook
, pytest-xdist
, numpy
}:

buildPythonPackage rec {
  pname = "demes";
  version = "0.2.3";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nmE7ZbR126J3vKdR3h83qJ/V602Fa6J3M6IJnIqCNhc=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    ruamel-yaml
    attrs
  ];

  postPatch = ''
    # remove coverage arguments to pytest
    sed -i '/--cov/d' setup.cfg
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    numpy
  ];

  pytestFlagsArray = [
    # pytest.PytestRemovedIn8Warning: Passing None has been deprecated.
    "-W" "ignore::pytest.PytestRemovedIn8Warning"
  ];

  disabledTestPaths = [
    "tests/test_spec.py"
  ];

  pythonImportsCheck = [
    "demes"
  ];

  meta = with lib; {
    description = "Tools for describing and manipulating demographic models";
    mainProgram = "demes";
    homepage = "https://github.com/popsim-consortium/demes-python";
    license = licenses.isc;
    maintainers = with maintainers; [ alxsimon ];
  };
}
