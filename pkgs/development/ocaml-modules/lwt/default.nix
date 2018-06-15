{ stdenv, fetchzip, pkgconfig, ncurses, libev, jbuilder
, ocaml, findlib, camlp4, cppo
, ocaml-migrate-parsetree, ppx_tools_versioned, result
}:

stdenv.mkDerivation rec {
  version = "3.3.0";
  name = "ocaml${ocaml.version}-lwt-${version}";

  src = fetchzip {
    url = "https://github.com/ocsigen/lwt/archive/${version}.tar.gz";
    sha256 = "0n87hcyl4svy0risj439wyfq6bl77qxq3nraqgdr1qbz5lskbq2j";
  };

  preConfigure = ''
    ocaml src/util/configure.ml -use-libev true -use-camlp4 true
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses ocaml findlib jbuilder camlp4 cppo
    ocaml-migrate-parsetree ppx_tools_versioned ];
  propagatedBuildInputs = [ libev result ];

  installPhase = ''
    ocaml src/util/install_filter.ml
    ${jbuilder.installPhase}
  '';

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
  };
}
