{ stdenv, fetchFromGitLab, coq, stdpp }:

stdenv.mkDerivation rec {
  version = "3.2.0";
  name = "coq${coq.coq-version}-iris-${version}";
  src = fetchFromGitLab {
    domain = "gitlab.mpi-sws.org";
    owner = "iris";
    repo = "iris";
    rev = "iris-${version}";
    sha256 = "10dfi7qx6j5w6kbmbrf05xh18jwxr9iz5g7y0f6157msgvl081xs";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ stdpp ];

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
    compatibleCoqVersions = v: builtins.elem v [ "8.7" "8.8" "8.9" "8.10" ];
  };

}
