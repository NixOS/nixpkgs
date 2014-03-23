{stdenv, fetchurl, ncurses, ocaml, findlib, ocaml_pcre, camlzip, openssl, ocaml_ssl, cryptokit }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ocamlnet-3.7.3";

  src = fetchurl {
    url = http://download.camlcity.org/download/ocamlnet-3.7.3.tar.gz;
    sha256 = "0s24icyrxkqqai91rgxpf52s1fx70j7p12c8vq9vcmvdhll6kp2d";
  };

  buildInputs = [ncurses ocaml findlib ocaml_pcre camlzip openssl ocaml_ssl cryptokit];

  propagatedbuildInputs = [ncurses ocaml_pcre camlzip openssl ocaml_ssl cryptokit];

  patches = [ ./configure.patch ];

  createFindlibDestdir = true;

  dontAddPrefix = true;

  preConfigure = ''
    configureFlagsArray=(
      -bindir $out/bin
      -enable-ssl
      -enable-zip
      -enable-pcre
      -enable-crypto
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
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
