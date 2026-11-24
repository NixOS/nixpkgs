{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  version ? "2.1.2",
}:

stdenv.mkDerivation {
  pname = "cmdliner";
  inherit version;

  src = fetchurl {
    url = "https://erratique.ch/software/cmdliner/releases/cmdliner-${version}.tbz";
    hash =
      {
        "1.0.4" = "sha256-XCqT1Er4o4mWosD4D715cP5HUfEEvkcMr6BpNT/ABMA=";
        "1.3.0" = "sha256-joGA9XO0QPanqMII2rLK5KgjhP7HMtInhNG7bmQWjLs=";
        "2.1.2" = "sha256-g5XmIAViTDHJ9y0OaITVyW/sa/LF6N6L9+hLddZii50=";
      }
      ."${version}";
  };

  nativeBuildInputs = [ ocaml ];

  makeFlags = [ "PREFIX=$(out)" ];
  installTargets = "install install-doc";
  installFlags = [
    "LIBDIR=$(out)/lib/ocaml/${ocaml.version}/site-lib/cmdliner"
    "DOCDIR=$(out)/share/doc/cmdliner"
  ];
  postInstall = ''
    mv $out/lib/ocaml/${ocaml.version}/site-lib/cmdliner/{opam,cmdliner.opam}
  '';

  meta = {
    homepage = "https://erratique.ch/software/cmdliner";
    description = "OCaml module for the declarative definition of command line interfaces";
    license = lib.licenses.isc;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
