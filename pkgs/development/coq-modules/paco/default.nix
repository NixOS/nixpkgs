{stdenv, fetchurl, coq, unzip}:

stdenv.mkDerivation rec {

  name = "coq-paco-${coq.coq-version}-${version}";
  version = "1.2.8";

  src = fetchurl {
    url = "http://plv.mpi-sws.org/paco/paco-${version}.zip";
    sha256 = "1lcmdr0y2d7gzyvr8dal3pi7fibbd60bpi1l32fw89xiyrgqhsqy";
  };

  buildInputs = [ coq.ocaml coq.camlp5 unzip ];
  propagatedBuildInputs = [ coq ];

  preBuild = "cd src";

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Paco
    cp -pR *.vo $COQLIB/user-contrib/Paco
  '';

  meta = with stdenv.lib; {
    homepage = http://plv.mpi-sws.org/paco/;
    description = "A Coq library implementing parameterized coinduction";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" ];
  };

}
