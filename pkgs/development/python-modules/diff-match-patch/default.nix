{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "diff-match-patch";
  version = "20200713";

  meta = {
    homepage = "https://github.com/diff-match-patch-python/diff-match-patch";
    description = "Diff, Match and Patch libraries for Plain Text";
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "da6f5a01aa586df23dfc89f3827e1cafbb5420be9d87769eeb079ddfd9477a18";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest -v diff_match_patch.tests
  '';
}
