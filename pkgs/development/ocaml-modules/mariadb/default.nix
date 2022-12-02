{ lib, fetchurl, stdenv
, ocaml, findlib, ocamlbuild
, ctypes, mariadb, libmysqlclient }:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.07")
  "mariadb is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-mariadb";
  version = "1.1.6";

  src = fetchurl {
    url = "https://github.com/andrenth/ocaml-mariadb/releases/download/${version}/ocaml-mariadb-${version}.tar.gz";
    sha256 = "sha256-3/C1Gz6luUzS7oaudLlDHMT6JB2v5OdbLVzJhtayHGM=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ mariadb libmysqlclient ];
  propagatedBuildInputs = [ ctypes ];

  strictDeps = true;

  preInstall = "mkdir -p $OCAMLFIND_DESTDIR/stublibs";

  meta = {
    description = "OCaml bindings for MariaDB";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://github.com/andrenth/ocaml-mariadb";
    inherit (ocaml.meta) platforms;
  };
}
