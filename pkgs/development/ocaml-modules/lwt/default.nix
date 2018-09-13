{ stdenv, fetchzip, pkgconfig, ncurses, libev, jbuilder
, ocaml, findlib, cppo
, ocaml-migrate-parsetree, ppx_tools_versioned, result
, withP4 ? true
, camlp4 ? null
}:

stdenv.mkDerivation rec {
  version = "3.3.0";
  name = "ocaml${ocaml.version}-lwt-${version}";

  src = fetchzip {
    url = "https://github.com/ocsigen/lwt/archive/${version}.tar.gz";
    sha256 = "0n87hcyl4svy0risj439wyfq6bl77qxq3nraqgdr1qbz5lskbq2j";
  };

  preConfigure = ''
    ocaml src/util/configure.ml -use-libev true -use-camlp4 ${if withP4 then "true" else "false"}
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses ocaml findlib jbuilder cppo
    ocaml-migrate-parsetree ppx_tools_versioned ]
  ++ stdenv.lib.optional withP4 camlp4;
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
