{ stdenv, fetchFromGitHub, coq }:

let param =
  {
    "8.6" = {
      version = "1.0-beta";
      rev = "v1.0-beta";
      sha256 = "00pzlh5ij7s2hmpvimq1hjq3fjf0nrk997l3dl51kigx5r5dnvxd";
    };

    "8.7" = {
      version = "cdf8c53";
      rev = "cdf8c53f1f2274b29506f53bff476409ce717dc5";
      sha256 = "0ipjzmviwnp0ippbkn03ld4j4j0dkzmyidmj4dvpdvymrkv31ai1";
    };

  }."${coq.coq-version}"
; in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-equations-${version}";
  version = "${param.version}";

  src = fetchFromGitHub {
    owner = "mattam82";
    repo = "Coq-Equations";
    rev = "${param.rev}";
    sha256 = "${param.sha256}";
  };

  buildInputs = [ coq.ocaml coq.camlp5 coq.findlib coq ];

  preBuild = "coq_makefile -f _CoqProject -o Makefile";

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://mattam82.github.io/Coq-Equations/;
    description = "A plugin for Coq to add dependent pattern-matching";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
