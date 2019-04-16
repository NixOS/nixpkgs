{ stdenv, fetchFromGitHub, coq, mathcomp-bigenough, mathcomp-finmap }:

stdenv.mkDerivation rec {
  version = "0.2.0";
  name = "coq${coq.coq-version}-mathcomp-analysis-${version}";

  src = fetchFromGitHub {
    owner = "math-comp";
    repo = "analysis";
    rev = version;
    sha256 = "1186xjxgns4ns1szyi931964bjm0mp126qzlv10mkqqgfw07nhrd";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ mathcomp-bigenough mathcomp-finmap ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = {
    description = "Analysis library compatible with Mathematical Components";
    inherit (src.meta) homepage;
    inherit (coq.meta) platforms;
    license = stdenv.lib.licenses.cecill-c;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.8" "8.9" ];
  };
}
