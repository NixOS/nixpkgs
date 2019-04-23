{ stdenv, fetchFromGitHub, coq, mathcomp }:

let param =
  if stdenv.lib.versionAtLeast mathcomp.version "1.8.0"
  then {
    version = "1.2.0";
    sha256 = "0b6wrdr0d7rcnv86s37zm80540jl2wmiyf39ih7mw3dlwli2cyj4";
  } else {
    version = "1.1.0";
    sha256 = "05df59v3na8jhpsfp7hq3niam6asgcaipg2wngnzxzqnl86srp2a";
  }
; in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "coq${coq.coq-version}-mathcomp-finmap-${version}";

  src = fetchFromGitHub {
    owner = "math-comp";
    repo = "finmap";
    rev = version;
    inherit (param) sha256;
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ mathcomp ];

  installFlags = "-f Makefile.coq COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = {
    description = "A finset and finmap library";
    inherit (src.meta) homepage;
    inherit (mathcomp.meta) platforms license;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" "8.9" ];
  };
}
