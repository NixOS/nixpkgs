{ lib, buildPythonPackage, fetchPypi, python-dateutil, sigtools, six, attrs, od
, docutils, repeated_test, pygments, unittest2, pytestCheckHook }:

buildPythonPackage rec {
  pname = "clize";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3177a028e4169d8865c79af82bdd441b24311d4bd9c0ae8803641882d340a51d";
  };

  checkInputs =
    [ pytestCheckHook python-dateutil pygments repeated_test unittest2 ];

  propagatedBuildInputs = [ attrs docutils od sigtools six ];

  pythonImportsCheck = [ "clize" ];

  meta = with lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
