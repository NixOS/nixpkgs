{ stdenv, fetchFromGitHub, which, coq }:

let params = {
  "8.11" = rec {
    version = "1.5.0";
    rev = "v${version}";
    sha256 = "0dlw869j6ib58i8fhbr7x3hq2cy088arihhfanv8i08djqml6g8x";
  };
  "8.12" = rec {
    version = "1.5.1";
    rev = "v${version}";
    sha256 = "1znjc8c8rivsawmz5bgm9ddl69p62p2pwxphvpap1gfmi5cp8lwi";
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
