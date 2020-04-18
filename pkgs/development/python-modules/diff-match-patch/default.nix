{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "diff-match-patch";
  version = "20181111";

  meta = {
    homepage = "https://github.com/diff-match-patch-python/diff-match-patch";
    description = "Diff, Match and Patch libraries for Plain Text";
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "a809a996d0f09b9bbd59e9bbd0b71eed8c807922512910e05cbd3f9480712ddb";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest -v diff_match_patch.tests
  '';
}
