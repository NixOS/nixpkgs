{stdenv, fetchurl, ocaml, findlib, which, ocaml_react, ocaml_ssl,
ocaml_lwt, ocamlnet, ocaml_pcre, cryptokit, tyxml, ipaddr, zlib,
libev, openssl, ocaml_sqlite3, tree, uutf, makeWrapper
}:

let mkpath = p: n:
  let v = stdenv.lib.getVersion ocaml; in
  "${p}/lib/ocaml/${v}/site-lib/${n}";
in

stdenv.mkDerivation {
  name = "ocsigenserver-2.6";

  src = fetchurl {
    url = https://github.com/ocsigen/ocsigenserver/archive/2.6.tar.gz;
    sha256 = "0638xvlr0sssvjarmdwhgh7vbgdx8wiyjwq73w1bkjfwl7qm21zp";
  };

  buildInputs = [ocaml which findlib ocaml_react ocaml_ssl ocaml_lwt
  ocamlnet ocaml_pcre cryptokit tyxml ipaddr zlib libev openssl
  ocaml_sqlite3 tree uutf makeWrapper ];

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
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };

}
