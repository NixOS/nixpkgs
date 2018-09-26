{ stdenv, fetchgit, coq, ssreflect }:

let param =
  {
    "8.6" = {
      version = "20180709";
      rev = "3b9ba7b26a64d49a55e8b6ccea570a7f32c11ead";
      sha256 = "0f2nr8dgn1ab7hr7jrdmr1zla9g9h8216q4yf4wnff9qkln8sbbs";
    };

    "8.7" = {
      version = "20180709";
      rev = "3b9ba7b26a64d49a55e8b6ccea570a7f32c11ead";
      sha256 = "0f2nr8dgn1ab7hr7jrdmr1zla9g9h8216q4yf4wnff9qkln8sbbs";
    };

  }."${coq.coq-version}"
; in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-category-theory-${param.version}";

  src = fetchgit {
    url = git://github.com/jwiegley/category-theory.git;
    inherit (param) rev sha256;
  };

  buildInputs = [ coq.ocaml coq.camlp5 coq.findlib ];
  propagatedBuildInputs = [ coq ssreflect ];

  enableParallelBuilding = false;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jwiegley/category-theory;
    description = "A formalization of category theory in Coq for personal study and practical work";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" ];
  };

}
