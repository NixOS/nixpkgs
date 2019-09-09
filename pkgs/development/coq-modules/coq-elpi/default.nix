{ stdenv, fetchFromGitHub, which, coq }:

let params = {
  "8.10" = {
    version = "master";
    rev = "bc7134deba1aacc7ecd2f5d1032bdf05b125c568";
    sha256 = "188avk9irwjsbs5ya4ka01mpk3vw4397kv2rmsncqrrrsa1pdddk";
  };
};
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-elpi-${param.version}";

  src = fetchFromGitHub {
    owner = "LPCIC";
    repo = "coq-elpi";
    inherit (param) rev sha256;
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq coq.ocaml ] ++ (with coq.ocamlPackages; [ findlib elpi ]);

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = {
    description = "Coq plugin embedding ELPI.";
    maintainers = [ stdenv.lib.maintainers.cohencyril ];
    license = stdenv.lib.licenses.lgpl21;
    inherit (coq.meta) platforms;
    inherit (src.meta) homepage;
  };

  passthru = {
    compatibleCoqVersions = stdenv.lib.flip builtins.hasAttr params;
  };
}
