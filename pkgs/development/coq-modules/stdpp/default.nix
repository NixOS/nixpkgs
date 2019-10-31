{ stdenv, fetchFromGitLab, coq }:

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-stdpp-${version}";
  version = "1.2.1";
  src = fetchFromGitLab {
    domain = "gitlab.mpi-sws.org";
    owner = "iris";
    repo = "stdpp";
    rev = "coq-stdpp-${version}";
    sha256 = "1lczybg1jq9drbi8nzrlb0k199x4n07aawjwfzrl3qqc0w8kmvdz";
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
    compatibleCoqVersions = v: builtins.elem v [ "8.7" "8.8" "8.9" "8.10" ];
  };

}
