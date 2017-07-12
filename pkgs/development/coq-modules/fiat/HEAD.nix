{stdenv, fetchFromGitHub, coq, python27}:

stdenv.mkDerivation rec {

  name = "coq-fiat-${coq.coq-version}-unstable-${version}";
  version = "2016-10-24";

  src = fetchFromGitHub {
    owner = "mit-plv";
    repo = "fiat";
    rev = "7feb6c64be9ebcc05924ec58fe1463e73ec8206a";
    sha256 = "16y57vibq3f5i5avgj80f4i3aw46wdwzx36k5d3pf3qk17qrlrdi";
  };

  buildInputs = [ coq.ocaml coq.camlp5 python27 ];
  propagatedBuildInputs = [ coq ];

  doCheck = false;

  enableParallelBuilding = false;
  buildPhase = "make -j$NIX_BUILD_CORES";

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Fiat
    cp -pR src/* $COQLIB/user-contrib/Fiat
  '';

  meta = with stdenv.lib; {
    homepage = http://plv.csail.mit.edu/fiat/;
    description = "A library for the Coq proof assistant for synthesizing efficient correct-by-construction programs from declarative specifications";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
