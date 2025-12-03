{
  lib,
  fetchurl,
  stdenv,
  fetchpatch,
  ocaml,
  findlib,
  ocamlbuild,
  camlp-streams,
  ctypes,
  mariadb,
  libmysqlclient,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-mariadb";
  version = "1.1.6";

  src = fetchurl {
    url = "https://github.com/andrenth/ocaml-mariadb/releases/download/${version}/ocaml-mariadb-${version}.tar.gz";
    sha256 = "sha256-3/C1Gz6luUzS7oaudLlDHMT6JB2v5OdbLVzJhtayHGM=";
  };

  patches =
    lib.lists.map
      (
        x:
        fetchpatch {
          url = "https://github.com/andrenth/ocaml-mariadb/commit/${x.path}.patch";
          inherit (x) hash;
        }
      )
      [
        {
          path = "9db2e4d8dec7c584213d0e0f03d079a36a35d9d5";
          hash = "sha256-heROtU02cYBJ5edIHMdYP1xNXcLv8h79GYGBuudJhgE=";
        }
        {
          path = "40cd3102bc7cce4ed826ed609464daeb1bbb4581";
          hash = "sha256-YVsAMJiOgWRk9xPaRz2sDihBYLlXv+rhWtQIMOVLtSg=";
        }
      ];

  postPatch = ''
    substituteInPlace setup.ml --replace '#use "topfind"' \
      '#directory "${findlib}/lib/ocaml/${ocaml.version}/site-lib/";; #use "topfind"'
  '';

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
  ];
  buildInputs = [
    mariadb
    libmysqlclient
    camlp-streams
    ocamlbuild
  ];
  propagatedBuildInputs = [ ctypes ];

  strictDeps = true;

  preInstall = "mkdir -p $OCAMLFIND_DESTDIR/stublibs";

  meta = {
    description = "OCaml bindings for MariaDB";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://github.com/andrenth/ocaml-mariadb";
    inherit (ocaml.meta) platforms;
    broken = !(lib.versionAtLeast ocaml.version "4.07");
  };
}
