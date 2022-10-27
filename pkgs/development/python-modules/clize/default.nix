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
, setuptools
, sigtools
, unittest2
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
    setuptools
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

  # repeated_test no longer exists in nixpkgs
  # also see: https://github.com/epsy/clize/issues/74
  doCheck = false;
  checkInputs = [
    pytestCheckHook
    python-dateutil
    pygments
    unittest2
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
