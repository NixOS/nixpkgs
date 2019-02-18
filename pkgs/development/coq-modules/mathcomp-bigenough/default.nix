{ stdenv, fetchFromGitHub, coq, mathcomp }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  name = "coq${coq.coq-version}-mathcomp-bigenough-${version}";

  src = fetchFromGitHub {
    owner = "math-comp";
    repo = "bigenough";
    rev = version;
    sha256 = "10g0gp3hk7wri7lijkrqna263346wwf6a3hbd4qr9gn8hmsx70wg";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ mathcomp ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = {
    description = "A small library to do epsilon - N reasonning";
    inherit (src.meta) homepage;
    inherit (mathcomp.meta) platforms license;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" ];
  };
}
