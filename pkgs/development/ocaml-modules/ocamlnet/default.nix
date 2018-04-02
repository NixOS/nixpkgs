{ stdenv, fetchurl, pkgconfig, ncurses, ocaml, findlib, ocaml_pcre, camlzip
, gnutls, nettle, fetchpatch
}:

let version = "4.1.5"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ocamlnet-${version}";

  src = fetchurl {
    url = "http://download.camlcity.org/download/ocamlnet-${version}.tar.gz";
    sha256 = "1ppcd2zjhj6s3ib9q8dngnr53qlmkhvv7a8hzp88r79k6jygn4cm";
  };

  patches = [ (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/ocamlnet/ocamlnet.4.1.5/files/netgzip.patch";
      sha256 = "1say7zzgk24qcy9m91gcfgvz4fv7nksx4j5qnbxyq8wqw0g88ba0";
    })
  ];

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
