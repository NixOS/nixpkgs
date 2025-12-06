{
  lib,
  stdenv,
  fetchurl,
  ocaml,
}:

stdenv.mkDerivation rec {
  pname = "cmdliner";
  version = "2.1.0";

  src = fetchurl {
    url = "https://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "sha256-iBTGFM1D1S/R68ivWjHZElwhTEmPpgVmDk7Rlf+ENOk=";
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
    description = "OCaml module for the declarative definition of command line interfaces";
    license = licenses.isc;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.vbgl ];
    broken = !(lib.versionAtLeast ocaml.version "4.08");
  };
}
