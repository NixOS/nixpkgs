{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  pname = "ocaml-iso8601";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "sagotch";
    repo = "ISO8601.ml";
    rev = version;
    sha256 = "sha256-sXnYAJcU88797orzzfbA2XG91Lk8mDV677J1Am5o7Xo=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = {
    homepage = "https://ocaml-community.github.io/ISO8601.ml/";
    description = "ISO 8601 and RFC 3999 date parsing for OCaml";
    license = lib.licenses.mit;
    platforms = ocaml.meta.platforms or [ ];
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
