{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, result }:

stdenv.mkDerivation rec {
  pname = "cmdliner";
  version = "1.1.1";

  src = fetchurl {
    url = "https://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "sha256-oa6Hw6eZQO+NHdWfdED3dtHckm4BmEbdMiAuRkYntfs=";
  };

  minimalOCamlVersion = "4.08";
  nativeBuildInputs = [ ocaml ];

  makeFlags = [ "PREFIX=$(out)" ];
  installTargets = "install install-doc";
  installFlags = [
    "LIBDIR=$(out)/lib/ocaml/${ocaml.version}/site-lib/${pname}"
    "DOCDIR=$(out)/share/doc/${pname}"
  ];
  postInstall = ''
    mv $out/lib/ocaml/${ocaml.version}/site-lib/${pname}/{opam,${pname}.opam}
  '';

  meta = with lib; {
    homepage = "https://erratique.ch/software/cmdliner";
    description = "An OCaml module for the declarative definition of command line interfaces";
    license = licenses.isc;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.vbgl ];
  };
}
