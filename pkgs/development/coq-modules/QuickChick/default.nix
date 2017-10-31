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
      version = "20170616";
      rev = "366ee3f8e599b5cab438a63a09713f44ac544c5a";
      sha256 = "06kwnrfndnr6w8bmaa2s0i0rkqyv081zj55z3vcyn0wr6x6mlsz9";
    };

  }."${coq.coq-version}"
; in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-QuickChick-${param.version}";

  src = fetchgit {
    url = git://github.com/QuickChick/QuickChick.git;
    inherit (param) rev sha256;
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ssreflect ];

  enableParallelBuilding = true;

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = git://github.com/QuickChick/QuickChick.git;
    description = "Randomized property-based testing plugin for Coq; a clone of Haskell QuickCheck";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
