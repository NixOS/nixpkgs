{ coq, mkCoqDerivation, mathcomp, mathcomp-finmap, mathcomp-bigenough, mathcomp-real-closed,
  hierarchy-builder, lib, version ? null }:

with lib;
let mca = mkCoqDerivation {

  namePrefix = [ "coq" "mathcomp" ];
  pname = "analysis";
  owner = "math-comp";

  release."0.5.3".sha256 = "sha256-1NjFsi5TITF8ZWx1NyppRmi8g6YaoUtTdS9bU/sUe5k=";
  release."0.5.2".sha256 = "0yx5p9zyl8jv1vg7rgkyq8dqzkdnkqv969mi62whmhkvxbavgzbw";
  release."0.5.1".sha256 = "1hnzqb1gxf88wgj2n1b0f2xm6sxg9j0735zdsv6j12hlvx5lwk68";
  release."0.3.13".sha256 = "sha256-Yaztew79KWRC933kGFOAUIIoqukaZOdNOdw4XszR1Hg=";
  release."0.3.10".sha256 = "sha256-FBH2c8QRibq5Ycw/ieB8mZl0fDiPrYdIzZ6W/A3pIhI=";
  release."0.3.9".sha256 = "sha256-uUU9diBwUqBrNRLiDc0kz0CGkwTZCUmigPwLbpDOeg4=";
  release."0.3.6".sha256 = "0g2j7b2hca4byz62ssgg90bkbc8wwp7xkb2d3225bbvihi92b4c5";
  release."0.3.4".sha256 = "18mgycjgg829dbr7ps77z6lcj03h3dchjbj5iir0pybxby7gd45c";
  release."0.3.3".sha256 = "1m2mxcngj368vbdb8mlr91hsygl430spl7lgyn9qmn3jykack867";
  release."0.3.1".sha256 = "1iad288yvrjv8ahl9v18vfblgqb1l5z6ax644w49w9hwxs93f2k8";
  release."0.2.3".sha256 = "0p9mr8g1qma6h10qf7014dv98ln90dfkwn76ynagpww7qap8s966";

  inherit version;
  defaultVersion = with versions; switch [ coq.version mathcomp.version ]  [
      { cases = [ (isGe "8.14") (isGe "1.13.0") ];               out = "0.5.3"; }
      { cases = [ (isGe "8.14") (range "1.13" "1.15") ];         out = "0.5.2"; }
      { cases = [ (isGe "8.13") (range "1.13" "1.14") ];         out = "0.5.1"; }
      { cases = [ (range "8.13" "8.15") (range "1.12" "1.14") ]; out = "0.3.13"; }
      { cases = [ (range "8.11" "8.14") (isGe "1.12.0") ];       out = "0.3.10"; }
      { cases = [ (range "8.11" "8.13") "1.11.0" ];              out = "0.3.4"; }
      { cases = [ (range "8.10" "8.12") "1.11.0" ];              out = "0.3.3"; }
      { cases = [ (range "8.10" "8.11") "1.11.0" ];              out = "0.3.1"; }
      { cases = [ (range "8.8"  "8.11") (range "1.8" "1.10") ];  out = "0.2.3"; }
    ] null;

  propagatedBuildInputs =
    [ mathcomp.ssreflect mathcomp.field
      mathcomp-finmap mathcomp-bigenough mathcomp-real-closed ];

  meta = {
    description = "Analysis library compatible with Mathematical Components";
    maintainers = [ maintainers.cohencyril ];
    license = licenses.cecill-c;
  };
}; in
mca.overrideAttrs (o:
  let ext = { propagatedBuildInputs = o.propagatedBuildInputs
                                      ++ [ hierarchy-builder ]; };
  in with versions; switch o.version [
    {case = "dev";        out = ext;}
    {case = isGe "0.3.4"; out = ext;}
  ] {}
)
