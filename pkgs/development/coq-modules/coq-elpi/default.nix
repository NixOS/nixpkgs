{ stdenv, fetchFromGitHub, which, coq }:

let params = {
  "8.10" = rec {
    version = "1.3.0";
    rev = "v${version}";
    sha256 = "1bbadh4qmsm0c5qw41apf4k8va6d44rpw294mc6pg556nmma87ra";
  };
  "8.11" = rec {
    version = "1.3.1";
    rev = "v${version}";
    sha256 = "06dg0i1jay9anhx68jfki5qs2g481n3s4q3m124qniyadlx80bh3";
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
