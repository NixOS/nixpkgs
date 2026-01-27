{
  lib,
  stdenv,
  fetchurl,
  ocaml,
}:

let
  pname = "cmdliner";
  version = "2.1.0";
  src = fetchurl {
    url = "https://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "1s9lhkzrblaf1rk0b9lg95622p0jv4qmmby8xg8jzma3rlacc548";
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
    broken = !(lib.versionAtLeast ocaml.version "4.08");
  };
}
