{ stdenv, fetchFromGitLab, coq, stdpp }:

stdenv.mkDerivation rec {
  version = "3.3.0";
  name = "coq${coq.coq-version}-iris-${version}";
  src = fetchFromGitLab {
    domain = "gitlab.mpi-sws.org";
    owner = "iris";
    repo = "iris";
    rev = "iris-${version}";
    sha256 = "0az4gkp5m8sq0p73dlh0r7ckkzhk7zkg5bndw01bdsy5ywj0vilp";
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
    compatibleCoqVersions = v: builtins.elem v [ "8.9" "8.10" "8.11" "8.12" ];
  };

}
