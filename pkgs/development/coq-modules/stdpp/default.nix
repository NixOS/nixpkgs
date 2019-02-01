{ stdenv, fetchzip, coq }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-stdpp-1.1";
  src = fetchzip {
    url = "https://gitlab.mpi-sws.org/robbertkrebbers/coq-stdpp/-/archive/coq-stdpp-1.1.0/coq-stdpp-coq-stdpp-1.1.0.tar.gz";
    sha256 = "0z8zl288x9w32w06sjax01jcpy12wd5i3ygps58dl2hfy7r3lwg0";
  };

  buildInputs = [ coq ];

  enableParallelBuilding = true;

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = {
    homepage = "https://gitlab.mpi-sws.org/robbertkrebbers/coq-stdpp";
    description = "An extended “Standard Library” for Coq";
    inherit (coq.meta) platforms;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" ];
  };

}
