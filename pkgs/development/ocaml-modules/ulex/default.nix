{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild, camlp4 }:

let
  pname = "ulex";
  param =
    if lib.versionAtLeast ocaml.version "4.02" then {
      version = "1.2";
      sha256 = "08yf2x9a52l2y4savjqfjd2xy4pjd1rpla2ylrr9qrz1drpfw4ic";
    } else {
      version = "1.1";
      sha256 = "0cmscxcmcxhlshh4jd0lzw5ffzns12x3bj7h27smbc8waxkwffhl";
    };
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  inherit (param) version;

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = pname;
    rev = "v${version}";
    inherit (param) sha256;
  };

  createFindlibDestdir = true;

  nativeBuildInputs = [ ocaml findlib ocamlbuild camlp4 ];
  propagatedBuildInputs = [ camlp4 ];

  strictDeps = true;

  buildFlags = [ "all" "all.opt" ];

  meta = {
    inherit (src.meta) homepage;
    description = "A lexer generator for Unicode and OCaml";
    license = lib.licenses.mit;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.roconnor ];
  };
}
