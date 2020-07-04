{ stdenv, fetchurl, pkgconfig, ncurses, ocaml, findlib, ocaml_pcre, camlzip
, gnutls, nettle
}:

if stdenv.lib.versionOlder ocaml.version "4.02"
then throw "ocamlnet is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ocamlnet-${version}";
  version = "4.1.7";

  src = fetchurl {
    url = "http://download.camlcity.org/download/ocamlnet-${version}.tar.gz";
    sha256 = "0r9gl0lsgxk2achixxqzm8bm5l9jwc4vwihf0rvxxa9v9q9vfdhi";
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
    homepage = "http://projects.camlcity.org/projects/ocamlnet.html";
    description = "A library implementing Internet protocols (http, cgi, email, etc.) for OCaml";
    license = "Most Ocamlnet modules are released under the zlib/png license. The HTTP server module Nethttpd is, however, under the GPL.";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.maggesi
    ];
  };
}
