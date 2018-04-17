{stdenv, fetchurl, coq, unzip}:

stdenv.mkDerivation rec {

  name = "coq-heq-${coq.coq-version}-${version}";
  version = "0.92";

  src = fetchurl {
    url = "https://www.mpi-sws.org/~gil/Heq/download/Heq-${version}.zip";
    sha256 = "03y71c4qs6cmy3s2hjs05g7pcgk9sqma6flj15394yyxbvr9is1p";
  };

  buildInputs = [ coq.ocaml coq.camlp5 unzip ];
  propagatedBuildInputs = [ coq ];

  preBuild = "cd src";

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}";

  meta = with stdenv.lib; {
    homepage = https://www.mpi-sws.org/~gil/Heq/;
    description = "Heq : a Coq library for Heterogeneous Equality";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: !stdenv.lib.versionAtLeast v "8.8";
  };
}
