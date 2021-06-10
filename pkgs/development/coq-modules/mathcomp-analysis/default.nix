{ coq, mkCoqDerivation, mathcomp, mathcomp-finmap, mathcomp-bigenough, mathcomp-real-closed,
  hierarchy-builder, lib, version ? null, origin ? null }:

with lib;
mkCoqDerivation (mca: {

  namePrefix = [ "coq" "mathcomp" ];
  pname = "analysis";
  owner = "math-comp";

  release."0.3.6".sha256 = "0g2j7b2hca4byz62ssgg90bkbc8wwp7xkb2d3225bbvihi92b4c5";
  release."0.3.4".sha256 = "18mgycjgg829dbr7ps77z6lcj03h3dchjbj5iir0pybxby7gd45c";
  release."0.3.3".sha256 = "1m2mxcngj368vbdb8mlr91hsygl430spl7lgyn9qmn3jykack867";
  release."0.3.1".sha256 = "1iad288yvrjv8ahl9v18vfblgqb1l5z6ax644w49w9hwxs93f2k8";
  release."0.2.3".sha256 = "0p9mr8g1qma6h10qf7014dv98ln90dfkwn76ynagpww7qap8s966";

  inherit version origin;
  defaultVersion = with versions; switch [ coq.version mathcomp.version ]  [
      { cases = [ (range "8.11" "8.13") "1.12.0" ];             out = "0.3.6"; }
      { cases = [ (range "8.11" "8.13") "1.11.0" ];             out = "0.3.4"; }
      { cases = [ (range "8.10" "8.12") "1.11.0" ];             out = "0.3.3"; }
      { cases = [ (range "8.10" "8.11") "1.11.0" ];             out = "0.3.1"; }
      { cases = [ (range "8.8"  "8.11") (range "1.8" "1.10") ]; out = "0.2.3"; }
    ] null;

  propagatedBuildInputs =
    [ mathcomp.ssreflect mathcomp.field
      mathcomp-finmap mathcomp-bigenough mathcomp-real-closed ]
    ++ optional (versions.isGe "0.3.4" mca.version) hierarchy-builder;

  meta = {
    description = "Analysis library compatible with Mathematical Components";
    maintainers = [ maintainers.cohencyril ];
    license = licenses.cecill-c;
  };
})
