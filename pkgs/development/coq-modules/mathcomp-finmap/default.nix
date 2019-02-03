{ stdenv, fetchFromGitHub, coq, mathcomp }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "coq${coq.coq-version}-mathcomp-finmap-${version}";

  src = fetchFromGitHub {
    owner = "math-comp";
    repo = "finmap";
    rev = version;
    sha256 = "05df59v3na8jhpsfp7hq3niam6asgcaipg2wngnzxzqnl86srp2a";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ mathcomp ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = {
    description = "A finset and finmap library";
    inherit (src.meta) homepage;
    inherit (mathcomp.meta) platforms license;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" ];
  };
}
