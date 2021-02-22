{ stdenv, lib, fetchurl, pkg-config, ncurses, ocaml, findlib, ocaml_pcre, camlzip
, gnutls, nettle
}:

if lib.versionOlder ocaml.version "4.02"
then throw "ocamlnet is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ocamlnet-${version}";
  version = "4.1.8";

  src = fetchurl {
    url = "http://download.camlcity.org/download/ocamlnet-${version}.tar.gz";
    sha256 = "1x703mjqsv9nvffnkj5i36ij2s5zfvxxll2z1qj6a7p428b2yfnm";
  };

  nativeBuildInputs = [ pkg-config ];
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
      lib.maintainers.maggesi
    ];
  };
}
