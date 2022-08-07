{ lib, mkCoqDerivation, coq, ssreflect, coq-ext-lib, simple-io, version ? null }:

let recent = lib.versions.isGe "8.7" coq.coq-version; in
(mkCoqDerivation {
  pname = "QuickChick";
  owner = "QuickChick";
  inherit version;
  defaultVersion = with lib; with versions; lib.switch [ coq.coq-version ssreflect.version ] [
      { cases = [ (range "8.13" "8.15") pred.true  ]; out = "1.6.2"; }
      { cases = [ "8.13" pred.true  ]; out = "1.5.0"; }
      { cases = [ "8.12" pred.true  ]; out = "1.4.0"; }
      { cases = [ "8.11" pred.true  ]; out = "1.3.2"; }
      { cases = [ "8.10" pred.true  ]; out = "1.2.1"; }
      { cases = [ "8.9"  pred.true  ];  out = "1.1.0"; }
      { cases = [ "8.8"  pred.true  ];  out = "20190311"; }
      { cases = [ "8.7"  isLe "1.8" ];  out = "1.0.0"; }
      { cases = [ "8.6"  pred.true  ];  out = "20171102"; }
      { cases = [ "8.5"  pred.true  ];  out = "20170512"; }
    ] null;
  release."1.6.2".sha256    = "0g5q9zw3xd4zndihq96nxkq4w3dh05418wzlwdk1nnn3b6vbx6z0";
  release."1.5.0".sha256    = "1lq8x86vd3vqqh2yq6hvyagpnhfq5wmk5pg2z0xq7b7dcw7hyfkw";
  release."1.4.0".sha256    = "068p48pm5yxjc3yv8qwzp25bp9kddvxj81l31mjkyx3sdrsw3kyc";
  release."1.3.2".sha256    = "0lciwaqv288dh2f13xk2x0lrn6zyrkqy6g4yy927wwzag2gklfrs";
  release."1.2.1".sha256    = "17vz88xjzxh3q7hs6hnndw61r3hdfawxp5awqpgfaxx4w6ni8z46";
  release."1.1.0".sha256    = "1c34v1k37rk7v0xk2czv5n79mbjxjrm6nh3llg2mpfmdsqi68wf3";
  release."1.0.0".sha256    = "1gqy9a4yavd0sa7kgysf9gf2lq4p8dmn4h89y8081f2j8zli0w5y";
  release."20190311".rev    = "22af9e9a223d0038f05638654422e637e863b355";
  release."20190311".sha256 = "00rnr19lg6lg0haq1sy4ld38p7imzand6fc52fvfq27gblxkp2aq";
  release."20171102".rev    = "0fdb769e1dc87a278383b44a9f5102cc7ccbafcf";
  release."20171102".sha256 = "0fri4nih40vfb0fbr82dsi631ydkw48xszinq43lyinpknf54y17";
  release."20170512".rev    = "31eb050ae5ce57ab402db9726fb7cd945a0b4d03";
  release."20170512".sha256 = "033ch10i5wmqyw8j6wnr0dlbnibgfpr1vr0c07q3yj6h23xkmqpg";
  releaseRev = v: "v${v}";

  preConfigure = lib.optionalString recent
    "substituteInPlace Makefile --replace quickChickTool.byte quickChickTool.native";

  mlPlugin = true;
  nativeBuildInputs = lib.optional recent coq.ocamlPackages.ocamlbuild;
  propagatedBuildInputs = [ ssreflect ]
    ++ lib.optionals recent [ coq-ext-lib simple-io ];
  extraInstallFlags = [ "-f Makefile.coq" ];

  enableParallelBuilding = false;

  meta = with lib; {
    description = "Randomized property-based testing plugin for Coq; a clone of Haskell QuickCheck";
    maintainers = with maintainers; [ jwiegley ];
  };
}).overrideAttrs (o:
  let after_1_6 = lib.versions.isGe "1.6" o.version || o.version == "dev";
  in {
    nativeBuildInputs = o.nativeBuildInputs
    ++ lib.optional after_1_6 coq.ocamlPackages.cppo;
    propagatedBuildInputs = o.propagatedBuildInputs
    ++ lib.optionals after_1_6 (with coq.ocamlPackages; [ findlib zarith ]);
})
