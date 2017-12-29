{ stdenv, fetchgit, coq, ssreflect }:

let param =
  {
    "8.4" = {
      version = "20160529";
      rev = "a9e89f1d4246a787bf1d8873072077a319635c3e";
      sha256 = "14ng71p890q12xvsj00si2a3fjcbsap2gy0r8sxpw4zndnlq74wa";
    };

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
      version = "20171102";
      rev = "ddf746809c211fa7edfdbfe459d5a7e1cca47a44";
      sha256 = "0jg3x0w8p088b8369qx492hjpq09f9h2i0li6ph3pny6hdkpdzsi";
    };

  }."${coq.coq-version}"
; in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-QuickChick-${param.version}";

  src = fetchgit {
    url = git://github.com/QuickChick/QuickChick.git;
    inherit (param) rev sha256;
  };

  buildInputs = [ coq.ocaml coq.camlp5 coq.findlib ];
  propagatedBuildInputs = [ coq ssreflect ];

  enableParallelBuilding = false;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = git://github.com/QuickChick/QuickChick.git;
    description = "Randomized property-based testing plugin for Coq; a clone of Haskell QuickCheck";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
