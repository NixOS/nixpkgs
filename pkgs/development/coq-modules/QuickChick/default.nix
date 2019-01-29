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

    "8.7" = {
      version = "20171212";
      rev = "195e550a1cf0810497734356437a1720ebb6d744";
      sha256 = "0zm23y89z0h4iamy74qk9qi2pz2cj3ga6ygav0w79n0qyqwhxcq1";
    };
    "8.8" = rec {
      preConfigure = "substituteInPlace Makefile --replace quickChickTool.byte quickChickTool.native";
      version = "1.0.2";
      rev = "v${version}";
      sha256 = "1mcbsp07ra3gdcmir36pf27ig3xv8nagyfp7w5pwqi4gj9w81ffn";
      buildInputs = with coq.ocamlPackages; [ ocamlbuild num ];
      propagatedBuildInputs = [ coq-ext-lib simple-io ];
    };
  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-QuickChick-${param.version}";

  src = fetchFromGitHub {
    owner = "QuickChick";
    repo = "QuickChick";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq ]
  ++ (with coq.ocamlPackages; [ ocaml camlp5 findlib ])
  ++ (param.buildInputs or [])
  ;
  propagatedBuildInputs = [ ssreflect ] ++ (param.propagatedBuildInputs or []);

  enableParallelBuilding = false;

  preConfigure = param.preConfigure or null;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/QuickChick/QuickChick;
    description = "Randomized property-based testing plugin for Coq; a clone of Haskell QuickCheck";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };

}
