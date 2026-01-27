{
  lib,
  stdenv,
  fetchurl,
  ocaml,
}:

let
  pname = "cmdliner";
  version = "1.0.4";
  src = fetchurl {
    url = "https://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "1h04q0zkasd0mw64ggh4y58lgzkhg6yhzy60lab8k8zq9ba96ajw";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

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

  meta = {
    homepage = "https://erratique.ch/software/cmdliner";
    description = "OCaml module for the declarative definition of command line interfaces";
    license = lib.licenses.isc;
    inherit (ocaml.meta) platforms;
    maintainers = with lib.maintainers; [
      vbgl
      eureka-cpu
    ];
    broken = !(lib.versionAtLeast ocaml.version "4.03");
  };
}
