{stdenv, fetchurl, coq}:

stdenv.mkDerivation rec {

  name = "coq-bedrock-${coq.coq-version}-${version}";
  version = "20140722";

  src = fetchurl {
    url = "http://plv.csail.mit.edu/bedrock/bedrock-${version}.tgz";
    sha256 = "0aaa98q42rsy9hpsxji21bqznizfvf6fplsw6jq42h06j0049k80";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  buildPhase = ''
    make -j$NIX_BUILD_CORES -C src/reification
    make -j$NIX_BUILD_CORES -C src
    make -j$NIX_BUILD_CORES -C src native
    # make -j$NIX_BUILD_CORES -C platform
    # make -j$NIX_BUILD_CORES -C platform -f Makefile.cito
  '';

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Bedrock
    cp -pR src/* $COQLIB/user-contrib/Bedrock
  '';

  meta = with stdenv.lib; {
    homepage = http://plv.csail.mit.edu/bedrock/;
    description = "A library that turns Coq into a tool much like classical verification systems";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
