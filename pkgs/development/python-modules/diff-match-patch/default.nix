{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "diff-match-patch";
  version = "20121119";

  meta = {
    homepage = https://code.google.com/p/google-diff-match-patch/;
    description = "Diff, Match and Patch libraries for Plain Text";
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k1f3v8nbidcmmrk65m7h8v41jqi37653za9fcs96y7jzc8mdflx";
  };
}
