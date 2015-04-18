{stdenv, fetchurl, coq}:

stdenv.mkDerivation rec {

  name = "coq-fiat-${coq.coq-version}-${version}";
  version = "20141031";

  src = fetchurl {
    url = "http://plv.csail.mit.edu/fiat/releases/fiat-${version}.tar.gz";
    sha256 = "0c5jrcgbpdj0gfzg2q4naqw7frf0xxs1f451fnic6airvpaj0d55";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;
  doCheck = true;

  unpackPhase = ''
    mkdir fiat
    cd fiat
    tar xvzf ${src}
  '';

  buildPhase = "make -j$NIX_BUILD_CORES sources";
  checkPhase = "make -j$NIX_BUILD_CORES examples";

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Fiat
    cp -pR src/* $COQLIB/user-contrib/Fiat
  '';

  meta = with stdenv.lib; {
    homepage = http://plv.csail.mit.edu/fiat/;
    description = "Fiat is a library for the Coq proof assistant for synthesizing efficient correct-by-construction programs from declarative specifications";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
