{ stdenv, fetchFromGitHub, coq, ssreflect, coq-ext-lib, simple-io }:

let params =
  {
    "8.5" = {
      version = "20170512";
      rev = "31eb050ae5ce57ab402db9726fb7cd945a0b4d03";
      sha256 = "033ch10i5wmqyw8j6wnr0dlbnibgfpr1vr0c07q3yj6h23xkmqpg";
    };

    "8.6" = {
      version = "20171102";
      rev = "0fdb769e1dc87a278383b44a9f5102cc7ccbafcf";
      sha256 = "0fri4nih40vfb0fbr82dsi631ydkw48xszinq43lyinpknf54y17";
    };

    "8.8" = {
      version = "20190311";
      rev = "22af9e9a223d0038f05638654422e637e863b355";
      sha256 = "00rnr19lg6lg0haq1sy4ld38p7imzand6fc52fvfq27gblxkp2aq";
    };

    "8.9" = rec {
      version = "1.1.0";
      rev = "v${version}";
      sha256 = "1c34v1k37rk7v0xk2czv5n79mbjxjrm6nh3llg2mpfmdsqi68wf3";
    };

    "8.10" = rec {
      version = "1.2.1";
      rev = "v${version}";
      sha256 = "17vz88xjzxh3q7hs6hnndw61r3hdfawxp5awqpgfaxx4w6ni8z46";
    };

    "8.11" = rec {
      version = "1.3.1";
      rev = "v${version}";
      sha256 = "0cajan9w52faqrg42r9rxai4wzsggs86qar88w7lcb928jvcakml";
    };
  };
  param = params.${coq.coq-version};
in

let inherit (stdenv.lib) maintainers optional optionals versionAtLeast; in

let recent = versionAtLeast coq.coq-version "8.8"; in

stdenv.mkDerivation {

  name = "coq${coq.coq-version}-QuickChick-${param.version}";

  src = fetchFromGitHub {
    owner = "QuickChick";
    repo = "QuickChick";
    inherit (param) rev sha256;
  };

  preConfigure = stdenv.lib.optionalString recent
    "substituteInPlace Makefile --replace quickChickTool.byte quickChickTool.native";

  buildInputs = [ coq ]
  ++ (with coq.ocamlPackages; [ ocaml findlib ])
  ++ optionals (recent && !versionAtLeast coq.coq-version "8.10")
       (with coq.ocamlPackages; [ camlp5 ocamlbuild ])
  ++ optional recent coq.ocamlPackages.num
  ;
  propagatedBuildInputs = [ ssreflect ]
  ++ optionals recent [ coq-ext-lib simple-io ]
  ++ optional (versionAtLeast coq.coq-version "8.10")
       coq.ocamlPackages.ocamlbuild
  ;

  enableParallelBuilding = false;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = {
    homepage = "https://github.com/QuickChick/QuickChick";
    description = "Randomized property-based testing plugin for Coq; a clone of Haskell QuickCheck";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };

}
