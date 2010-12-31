{stdenv, fetchurl, ncurses, ocaml, findlib, ocaml_pcre, camlzip, openssl, ocaml_ssl}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "3.1";
in

stdenv.mkDerivation {
  name = "ocamlnet-${version}";

  src = fetchurl {
    url = "http://download.camlcity.org/download/ocamlnet-${version}.tar.gz";
    sha256 = "0kdc2540ad84j6haj9jxlwryz9cb8q8kjdr48f2wgvcaii38v9f5";
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
