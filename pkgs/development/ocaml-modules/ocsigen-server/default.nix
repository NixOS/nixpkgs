{ stdenv, fetchurl, ocaml, findlib, which, react, ssl
, ocamlnet, ocaml_pcre, cryptokit, tyxml, ipaddr, zlib,
libev, openssl, ocaml_sqlite3, tree, uutf, makeWrapper, camlp4
, camlzip, pgocaml, lwt2, lwt_react, lwt_ssl
}:

let mkpath = p: n:
  let v = stdenv.lib.getVersion ocaml; in
  "${p}/lib/ocaml/${v}/site-lib/${n}";
in

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.03" then {
    version = "2.9";
    sha256 = "0na3qa4h89f2wv31li63nfpg4151d0g8fply0bq59j3bhpyc85nd";
    buildInputs = [ lwt_react lwt_ssl ];
    ldpath = "";
  } else {
    version = "2.8";
    sha256 = "1v44qv2ixd7i1qinyhlzzqiffawsdl7xhhh6ysd7lf93kh46d5sy";
    buildInputs = [ lwt2 ];
    ldpath = "${mkpath lwt2 "lwt"}";
  }
; in

stdenv.mkDerivation {
  name = "ocsigenserver-${param.version}";

  src = fetchurl {
    url = "https://github.com/ocsigen/ocsigenserver/archive/${param.version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ocaml which findlib react ssl
  ocamlnet ocaml_pcre cryptokit tyxml ipaddr zlib libev openssl
  ocaml_sqlite3 tree uutf makeWrapper camlp4 pgocaml camlzip ]
  ++ (param.buildInputs or []);

  configureFlags = [ "--root $(out) --prefix /" ];

  dontAddPrefix = true;

  createFindlibDestdir = true;

  postFixup =
  ''
  rm -rf $out/var/run
  wrapProgram $out/bin/ocsigenserver \
    --prefix CAML_LD_LIBRARY_PATH : "${mkpath ssl "ssl"}:${param.ldpath}:${mkpath ocamlnet "netsys"}:${mkpath ocamlnet "netstring"}:${mkpath ocaml_pcre "pcre"}:${mkpath cryptokit "cryptokit"}:${mkpath ocaml_sqlite3 "sqlite3"}"
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
