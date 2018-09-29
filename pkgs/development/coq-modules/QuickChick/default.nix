{ stdenv, fetchFromGitHub, coq, ssreflect }:

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

  buildInputs = [ coq.ocaml coq.camlp5 coq.findlib ];
  propagatedBuildInputs = [ coq ssreflect ];

  enableParallelBuilding = false;

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
