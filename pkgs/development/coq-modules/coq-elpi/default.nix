{ stdenv, fetchFromGitHub, which, coq }:

let params = {
  "8.11" = rec {
    version = "1.6.0_8.11";
    rev = "v${version}";
    sha256 = "0ahxjnzmd7kl3gl38kyjqzkfgllncr2ybnw8bvgrc6iddgga7bpq";
  };
  "8.12" = rec {
    version = "1.6.0";
    rev = "v${version}";
    sha256 = "0kf99i43mlf750fr7fric764mm495a53mg5kahnbp6zcjcxxrm0b";
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

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

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
