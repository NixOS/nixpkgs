{ lib, buildPythonPackage, fetchFromGitHub, python }:

buildPythonPackage rec {
  pname = "diff-match-patch";
  version = "20200713";

  meta = {
    homepage = "https://github.com/diff-match-patch-python/diff-match-patch";
    description = "Diff, Match and Patch libraries for Plain Text";
    license = lib.licenses.asl20;
  };

  src = fetchFromGitHub {
     owner = "diff-match-patch-python";
     repo = "diff-match-patch";
     rev = "v20200713";
     sha256 = "0834fvsxyw52426lq0qd38vxjk5bpy03sqqg6byayxz5hml1qdqh";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest -v diff_match_patch.tests
  '';
}
