{ stdenv, fetchFromGitLab, coq }:

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-stdpp-${version}";
  version = "1.4.0";
  src = fetchFromGitLab {
    domain = "gitlab.mpi-sws.org";
    owner = "iris";
    repo = "stdpp";
    rev = "coq-stdpp-${version}";
    sha256 = "1m6c7ibwc99jd4cv14v3r327spnfvdf3x2mnq51f9rz99rffk68r";
  };

  buildInputs = [ coq ];

  enableParallelBuilding = true;

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = {
    inherit (src.meta) homepage;
    description = "An extended “Standard Library” for Coq";
    inherit (coq.meta) platforms;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.8" "8.9" "8.10" "8.11" "8.12" ];
  };

}
