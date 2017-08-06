{ stdenv, fetchurl, pkgconfig, ncurses, ocaml, findlib, ocaml_pcre, camlzip
, gnutls, nettle }:

stdenv.mkDerivation {
  name = "ocamlnet-4.1.2";

  src = fetchurl {
    url = http://download.camlcity.org/download/ocamlnet-4.1.2.tar.gz;
    sha256 = "1n0l9zlq7dc5yr43bpa4a0b6bxj3iyjkadbb41g59zlwa8hkk34i";
  };

  buildInputs = [ ncurses ocaml findlib ocaml_pcre camlzip gnutls pkgconfig nettle ];

  createFindlibDestdir = true;

  dontAddPrefix = true;

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
    homepage = http://projects.camlcity.org/projects/ocamlnet.html;
    description = "A library implementing Internet protocols (http, cgi, email, etc.) for OCaml";
    license = "Most Ocamlnet modules are released under the zlib/png license. The HTTP server module Nethttpd is, however, under the GPL.";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
    broken = stdenv.lib.versionAtLeast ocaml.version "4.05";
  };
}
