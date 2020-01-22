{ stdenv, fetchFromGitHub, coq, bignums }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-CoLoR-1.6.0";

  src = fetchFromGitHub {
    owner = "fblanqui";
    repo = "color";
    rev = "328aa06270584b578edc0d2925e773cced4f14c8";
    sha256 = "07sy9kw1qlynsqy251adgi8b3hghrc9xxl2rid6c82mxfsp329sd";
  };

  buildInputs = [ coq bignums ];
  enableParallelBuilding = false;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib ; {
    homepage = http://color.inria.fr/;
    description = "CoLoR is a library of formal mathematical definitions and proofs of theorems on rewriting theory and termination whose correctness has been mechanically checked by the Coq proof assistant.";
    maintainers = with maintainers; [ jpas jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" "8.9" ];
  };
}
