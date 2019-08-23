{ stdenv, fetchzip, coq, ssreflect, stdpp }:

stdenv.mkDerivation rec {
  version = "3.1.0";
  name = "coq${coq.coq-version}-iris-${version}";
  src = fetchzip {
    url = "https://gitlab.mpi-sws.org/FP/iris-coq/-/archive/iris-${version}/iris-coq-iris-${version}.tar.gz";
    sha256 = "0ipdb061jj205avxifshxkpyxxqykigmlxk2n5nvxj62gs3rl5j1";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ ssreflect stdpp ];

  enableParallelBuilding = true;

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = {
    homepage = "https://gitlab.mpi-sws.org/FP/iris-coq";
    description = "The Coq development of the Iris Project";
    inherit (coq.meta) platforms;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" ];
  };

}
