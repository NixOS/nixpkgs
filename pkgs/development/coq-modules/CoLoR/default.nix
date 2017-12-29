{ stdenv, fetchurl, coq, coqPackages }:

if !stdenv.lib.versionAtLeast coq.coq-version "8.6"
then throw "CoLoR is not available for Coq ${coq.coq-version}"
else

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-CoLoR-1.4.0";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/37205/color.1.4.0.tar.gz;
    sha256 = "1jsp9adsh7w59y41ihbwchryjhjpajgs9bhf8rnb4b3hzccqxgag";
  };

  buildInputs = [ coq coqPackages.bignums ];
  enableParallelBuilding = false;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = http://color.inria.fr/;
    description = "CoLoR is a library of formal mathematical definitions and proofs of theorems on rewriting theory and termination whose correctness has been mechanically checked by the Coq proof assistant.";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };
}
