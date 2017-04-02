{stdenv, fetchurl, ocaml, findlib, which, ocaml_react, ocaml_ssl,
ocaml_lwt, ocamlnet, ocaml_pcre, cryptokit, tyxml, ipaddr, zlib,
libev, openssl, ocaml_sqlite3, tree, uutf, makeWrapper, camlp4
, pgocaml
}:

let mkpath = p: n:
  let v = stdenv.lib.getVersion ocaml; in
  "${p}/lib/ocaml/${v}/site-lib/${n}";
in

stdenv.mkDerivation {
  name = "ocsigenserver-2.8";

  src = fetchurl {
    url = https://github.com/ocsigen/ocsigenserver/archive/2.8.tar.gz;
    sha256 = "1v44qv2ixd7i1qinyhlzzqiffawsdl7xhhh6ysd7lf93kh46d5sy";
  };

  buildInputs = [ocaml which findlib ocaml_react ocaml_ssl ocaml_lwt
  ocamlnet ocaml_pcre cryptokit tyxml ipaddr zlib libev openssl
  ocaml_sqlite3 tree uutf makeWrapper camlp4 pgocaml ];

  configureFlags = "--root $(out) --prefix /";

  dontAddPrefix = true;

  createFindlibDestdir = true;

  postFixup =
  ''
  rm -rf $out/var/run
  wrapProgram $out/bin/ocsigenserver \
    --prefix CAML_LD_LIBRARY_PATH : "${mkpath ocaml_ssl "ssl"}:${mkpath ocaml_lwt "lwt"}:${mkpath ocamlnet "netsys"}:${mkpath ocamlnet "netstring"}:${mkpath ocaml_pcre "pcre"}:${mkpath cryptokit "cryptokit"}:${mkpath ocaml_sqlite3 "sqlite3"}"
  '';

  dontPatchShebangs = true;

  meta = {
    homepage = http://ocsigen.org/ocsigenserver/;
    description = "A full featured Web server";
    longDescription =''
      A full featured Web server. It implements most features of the HTTP protocol, and has a very powerful extension mechanism that make very easy to plug your own OCaml modules for generating pages.
      '';
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };

}
