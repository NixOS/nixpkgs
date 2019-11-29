{ stdenv, fetchFromGitHub, coq, mathcomp-algebra }:

let
  version = "20190812";
in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-coq-bits-${version}";

  src = fetchFromGitHub {
    owner = "coq-community";
    repo = "coq-bits";
    rev = "f74498a6c67e97d9565e139d62be8eaae7111f06";
    sha256 = "1ibg37qxgkmpbpvc78qcb179bcnzl149z1kzwdm8n98xk5ibavrf";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ mathcomp-algebra ];

  enableParallelBuilding = true;

  installPhase = ''
    make -f Makefile CoqMakefile
    make -f CoqMakefile COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/coq-community/coq-bits;
    description = "A formalization of bitset operations in Coq";
    license = licenses.asl20;
    maintainers = with maintainers; [ ptival ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.7" "8.8" "8.9" "8.10" ];
  };
}
