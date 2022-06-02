{ lib
, buildPythonPackage
, fetchPypi

# propagtes
, sigtools
, six
, attrs
, od
, docutils

# extras: datetime
, python-dateutil

# tests
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace "docutils ~= 0.17.0" "docutils"
  '';

  propagatedBuildInputs = [
    attrs
    docutils
    od
    sigtools
    six
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

  pythonImportsCheck = [ "clize" ];

  meta = with lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
