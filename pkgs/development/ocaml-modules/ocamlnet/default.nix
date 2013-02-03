{stdenv, fetchurl, ncurses, ocaml, findlib, ocaml_pcre, camlzip, openssl, ocaml_ssl}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ocamlnet-3.6";

  src = fetchurl {
    url = http://download.camlcity.org/download/ocamlnet-3.6.tar.gz;
    sha256 = "306c20aee6512be3564c0f39872b70f929c06e1e893cfcf528ac47ae35cf7a69";
  };

  buildInputs = [ncurses ocaml findlib ocaml_pcre camlzip openssl ocaml_ssl];

  createFindlibDestdir = true;

  dontAddPrefix = true;

  preConfigure = ''
    configureFlagsArray=(
      -bindir $out/bin
      -enable-ssl
      -enable-zip
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
