{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, nose
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42d8ef819367516592a825746a18073ced42ca169ab1f5f4044134703e7a049c";
  };

  # python2 can't import a test fixture
  doCheck = !isPy27;
  checkInputs = [ nose ];
  checkPhase = ''
    PYTHONPATH=$PWD/tests:$PYTHONPATH
    nosetests \
      --ignore-files="test_classdef" \
      --ignore-files="test_objects" \
      --ignore-files="test_selected" \
      --exclude="test_the_rest" \
      --exclude="test_importable"
  '';
  # Tests seem to fail because of import pathing and referencing items/classes in modules.
  # Seems to be a Nix/pathing related issue, not the codebase, so disabling failing tests.

  meta = {
    description = "Serialize all of python (almost)";
    homepage = "https://github.com/uqfoundation/dill/";
    license = lib.licenses.bsd3;
  };
}
