{stdenv, fetchurl, ocaml, findlib, which, ocaml_react, ocaml_ssl, ocaml_lwt, ocamlnet, ocaml_pcre, cryptokit, tyxml, ocaml_ipaddr, zlib, libev, openssl, ocaml_sqlite3, tree}:

stdenv.mkDerivation {
  name = "ocsigenserver-2.4.0";
  
  src = fetchurl {
    url = https://github.com/ocsigen/ocsigenserver/archive/2.4.0.tar.gz;
    sha256 = "1fjj8g6ivyfsa0446w77rjihhbw0gh5pgx7brywql2shk999riby";
  };

  buildInputs = [ocaml which findlib ocaml_react ocaml_ssl ocaml_lwt ocamlnet ocaml_pcre cryptokit tyxml ocaml_ipaddr zlib libev openssl ocaml_sqlite3 tree];

  configureFlags = "--root $(out) --prefix /";

  dontAddPrefix = true;

  createFindlibDestdir = true;

  postFixup = 
  ''
  rm -rf $out/var/run
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
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };

}
