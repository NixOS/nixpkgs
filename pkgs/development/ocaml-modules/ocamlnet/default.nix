{ stdenv, fetchurl, pkgconfig, ncurses, ocaml, findlib, ocaml_pcre, camlzip
, gnutls, nettle_3_3 }:

# These overrides are just temporary, until ocamlnet supports nettle-3.4.
let gnutls_orig = gnutls; in
let gnutls = gnutls_orig.override { nettle = nettle_3_3; };
    nettle = nettle_3_3;
in

let version = "4.1.4"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ocamlnet-${version}";

  src = fetchurl {
    url = "http://download.camlcity.org/download/ocamlnet-${version}.tar.gz";
    sha256 = "0hhi3s4xas5i3p7214qfji5pvr7d30d89vnmkznxsfqj4v7dmhs6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses ocaml findlib ocaml_pcre camlzip gnutls nettle ];

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
  };
}
