{ stdenv, fetchgit, coq, ssreflect }:

let param =
  {
    "8.6" = {
      version = "20171214";
      rev = "babf9c013506da1dbd67171e4a3ae87fdb7e9d00";
      sha256 = "16fsf4cggx9s9fkijnpi4g614nmdb2yx7inzqqn070f8p959qcrd";
    };

    "8.7" = {
      version = "20171214";
      rev = "babf9c013506da1dbd67171e4a3ae87fdb7e9d00";
      sha256 = "16fsf4cggx9s9fkijnpi4g614nmdb2yx7inzqqn070f8p959qcrd";
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
    homepage = git://github.com/jwiegley/category-theory.git;
    description = "A formalization of category theory in Coq for personal study and practical work";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" ];
  };

}
