{ lib
, attrs
, buildPythonPackage
, docutils
, fetchPypi
, od
, pygments
, pytestCheckHook
, pythonOlder
, python-dateutil
, repeated-test
, setuptools-scm
, sigtools
}:

buildPythonPackage rec {
  pname = "clize";
  version = "5.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/cFpEvAN/Movd38xaE53Y+D9EYg/SFyHeqtlVUo1D0I=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    docutils
    od
    sigtools
  ];

  passthru.optional-dependencies = {
    datetime = [
      python-dateutil
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    python-dateutil
    pygments
    repeated-test
  ];

  pythonImportsCheck = [
    "clize"
  ];

  meta = with lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
