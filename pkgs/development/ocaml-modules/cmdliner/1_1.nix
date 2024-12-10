{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  result,
}:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "cmdliner 1.1 is not available for OCaml ${ocaml.version}"

  stdenv.mkDerivation
  rec {
    pname = "cmdliner";
    version = "1.2.0";

    src = fetchurl {
      url = "https://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
      sha256 = "sha256-r+0QWJAoOU/W9k6XscYX4r5w3m017kfgQjXaMandAHg=";
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
