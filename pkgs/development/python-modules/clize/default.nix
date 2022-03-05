{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, sigtools
, six
, attrs
, od
, docutils
, pygments
, unittest2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clize";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3177a028e4169d8865c79af82bdd441b24311d4bd9c0ae8803641882d340a51d";
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
