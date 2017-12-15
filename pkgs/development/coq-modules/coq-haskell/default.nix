{ stdenv, fetchgit, coq }:

let param =
  {
    "8.5" = {
      version = "20171214";
      rev = "d319043533585f60f0c89919a8370f85a9cf572b";
      sha256 = "154a8sx5igw86wby0ybk3rv5y21cji8489amgxhgqxfys9zmx2di";
    };

    "8.6" = {
      version = "20171214";
      rev = "d319043533585f60f0c89919a8370f85a9cf572b";
      sha256 = "154a8sx5igw86wby0ybk3rv5y21cji8489amgxhgqxfys9zmx2di";
    };

    "8.7" = {
      version = "20171214";
      rev = "d319043533585f60f0c89919a8370f85a9cf572b";
      sha256 = "154a8sx5igw86wby0ybk3rv5y21cji8489amgxhgqxfys9zmx2di";
    };

  }."${coq.coq-version}"
; in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-coq-haskell-${param.version}";

  src = fetchgit {
    url = git://github.com/jwiegley/coq-haskell.git;
    inherit (param) rev sha256;
  };

  buildInputs = [ coq.ocaml coq.camlp5 coq.findlib ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = false;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = git://github.com/jwiegley/coq-haskell.git;
    description = "A library for formalizing Haskell types and functions in Coq";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
