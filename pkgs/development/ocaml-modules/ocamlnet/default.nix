{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  which,
  ncurses,
  ocaml,
  findlib,
  ocaml_pcre,
  camlzip,
  gnutls,
  nettle,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocamlnet";
  version = "4.1.9";

  src = fetchurl {
    url = "http://download.camlcity.org/download/ocamlnet-${version}.tar.gz";
    hash = "sha256-+Y7RmXmEjxlJsbAB4wrBMrJU0PSnBRUMbc+QlLvsnO4=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    ocaml
    findlib
  ];
  buildInputs = [
    ncurses
    ocaml_pcre
    camlzip
    gnutls
    nettle
  ];

  strictDeps = true;

  createFindlibDestdir = true;

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  preConfigure = ''
    configureFlagsArray=(
      -bindir $out/bin
      -enable-gnutls
      -enable-zip
      -enable-pcre
      -disable-gtk2
      -with-nethttpd
      -datadir $out/lib/ocaml/${ocaml.version}/ocamlnet
    )
  '';

  buildPhase = ''
    make all
    make opt
  '';

  meta = {
    homepage = "http://projects.camlcity.org/projects/ocamlnet.html";
    description = "Library implementing Internet protocols (http, cgi, email, etc.) for OCaml";
    license =
      with lib.licenses;
      AND [
        mit
        bsd3
        gpl2Only
      ];
    inherit (ocaml.meta) platforms;
    broken = lib.versionOlder ocaml.version "4.02" || lib.versionAtLeast ocaml.version "5.0";
  };
}
