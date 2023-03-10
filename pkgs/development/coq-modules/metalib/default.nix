{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "metalib";
  owner = "plclub";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.14" "8.16"; out = "8.15"; }
    { case = range "8.10" "8.13"; out = "8.10"; }
  ] null;
  releaseRev = v: "coq${v}";
  release."8.15".sha256 = "0wbp058zwa4bkdjj38aysy2g1avf9nrh8q23a3dil0q00qczi616";
  release."8.10".sha256 = "0wbypc05d2lqfm9qaw98ynr5yc1p0ipsvyc3bh1rk9nz7zwirmjs";

  sourceRoot = "source/Metalib";

  meta = with lib; {
    license = licenses.mit;
    maintainers = [ maintainers.jwiegley ];
  };
}
