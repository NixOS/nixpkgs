{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, result }:

assert (lib.versionAtLeast ocaml.version "4.03");

stdenv.mkDerivation rec {
  pname = "cmdliner";
  version = "1.0.4";

  src = fetchurl {
    url = "https://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "1h04q0zkasd0mw64ggh4y58lgzkhg6yhzy60lab8k8zq9ba96ajw";
  };

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
