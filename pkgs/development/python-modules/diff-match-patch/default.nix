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
    sha256 = "063s8zcxz787xfg7d1wxpqh59fxg3iz85ww9zhyz4vaqm80mlvys";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest -v diff_match_patch.tests
  '';
}
