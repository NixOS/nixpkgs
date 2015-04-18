{stdenv, fetchurl, ocaml, findlib, which, ocaml_react, ocaml_ssl,
ocaml_lwt, ocamlnet, ocaml_pcre, cryptokit, tyxml, ocaml_ipaddr, zlib,
libev, openssl, ocaml_sqlite3, tree, uutf}:

stdenv.mkDerivation {
  name = "ocsigenserver-2.5";
  
  src = fetchurl {
    url = https://github.com/ocsigen/ocsigenserver/archive/2.5.tar.gz;
    sha256 = "0ayzlzjwg199va4sclsldlcp0dnwdj45ahhg9ckb51m28c2pw46r";
  };

  buildInputs = [ocaml which findlib ocaml_react ocaml_ssl ocaml_lwt
  ocamlnet ocaml_pcre cryptokit tyxml ocaml_ipaddr zlib libev openssl
  ocaml_sqlite3 tree uutf];

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
