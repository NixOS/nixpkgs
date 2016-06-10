{ stdenv, fetchurl, pkgconfig, ncurses, ocaml, findlib, ocaml_pcre, camlzip
, gnutls, nettle }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ocamlnet-4.1.1";

  src = fetchurl {
    url = http://download.camlcity.org/download/ocamlnet-4.1.1.tar.gz;
    sha256 = "1z0j542dfzfimsn4asw1ycb4ww561pv92cz6s6kxazvgx60c5rb1";
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
      -datadir $out/lib/ocaml/${ocaml_version}/ocamlnet
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
  };
}
