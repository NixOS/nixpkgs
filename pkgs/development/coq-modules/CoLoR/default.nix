{ stdenv, fetchurl, coq }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-CoLoR-1.3.0";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/36399/color.1.3.0.tar.gz;
    sha256 = "0n7431mc4a5bn9fsyk5167j2vnbxz4vgggjch4pm0x58lda8mxv1";
  };

  buildInputs = [ coq ];
  enableParallelBuilding = true;

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
