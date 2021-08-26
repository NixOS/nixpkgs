{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, sigtools
, six
, attrs
, od
, docutils
, repeated_test
, pygments
, unittest2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clize";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06p47i6hri006v7xbx7myj02as1a6f34rv88wfa9rb067p13nmyz";
  };

  checkInputs = [
    pytestCheckHook
    python-dateutil
    pygments
    repeated_test
    unittest2
  ];

  propagatedBuildInputs = [
    attrs
    docutils
    od
    sigtools
    six
  ];

  pythonImportsCheck = [ "clize" ];

  meta = with lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
