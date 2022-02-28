{ stdenv, lib, fetchurl, pkg-config, which, ncurses, ocaml, findlib, ocaml_pcre, camlzip
, gnutls, nettle
}:

if lib.versionOlder ocaml.version "4.02"
then throw "ocamlnet is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocamlnet";
  version = "4.1.9";

  src = fetchurl {
    url = "http://download.camlcity.org/download/ocamlnet-${version}.tar.gz";
    sha256 = "1vlwxjxr946gdl61a1d7yk859cijq45f60dhn54ik3w4g6cx33pr";
  };

  nativeBuildInputs = [ pkg-config which ocaml findlib ];
  buildInputs = [ ncurses ocaml_pcre camlzip gnutls nettle ];

  strictDeps = true;

  createFindlibDestdir = true;

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

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
      lib.maintainers.maggesi
    ];
  };
}
