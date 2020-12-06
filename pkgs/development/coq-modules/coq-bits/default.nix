{ stdenv, fetchFromGitHub, coq, mathcomp-algebra }:

let
  version = "20190812";
in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-coq-bits-${version}";

  src = fetchFromGitHub {
    owner = "coq-community";
    repo = "bits";
    rev = "1.0.0";
    sha256 = "0nv5mdgrd075dpd8bc7h0xc5i95v0pkm0bfyq5rj6ii1s54dwcjl";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ mathcomp-algebra ];

  enableParallelBuilding = true;

  installPhase = ''
    make -f Makefile CoqMakefile
    make -f CoqMakefile COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/coq-community/bits";
    description = "A formalization of bitset operations in Coq";
    license = licenses.asl20;
    maintainers = with maintainers; [ ptival ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.7" "8.8" "8.9" "8.10" "8.11" "8.12" ];
  };
}
