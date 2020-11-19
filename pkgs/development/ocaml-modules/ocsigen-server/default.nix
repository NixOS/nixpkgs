{ stdenv, fetchFromGitHub, which, ocaml, findlib, lwt_react, ssl, lwt_ssl
, lwt_log, ocamlnet, ocaml_pcre, cryptokit, tyxml, xml-light, ipaddr
, pgocaml, camlzip, ocaml_sqlite3
, makeWrapper, fetchpatch
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.06.1"
then throw "ocsigenserver is not available for OCaml ${ocaml.version}"
else

let mkpath = p: n:
  "${p}/lib/ocaml/${ocaml.version}/site-lib/${n}";
in

stdenv.mkDerivation rec {
  version = "2.16.0";
  pname = "ocsigenserver";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigenserver";
    rev = version;
    sha256 = "0dd7zfk8dlajv0297dswaaqh96hjk2ppy8zb67jbkd26nimahk9y";
  };

  # unreleased fix for Makefile typos breaking compilation
  patches = [ (fetchpatch {
    url = "https://github.com/ocsigen/ocsigenserver/commit/014aefc4e460686a361b974f16ebb7e0c993b36b.patch";
    sha256 = "0xda4fj8p5102lh9xmrn5mv3s0ps6yykqj3mpjf72gf4zd6fzcn7";
  }) ];

  buildInputs = [ which makeWrapper ocaml findlib
    lwt_react pgocaml camlzip ocaml_sqlite3
  ];

  propagatedBuildInputs = [ cryptokit ipaddr lwt_log lwt_ssl ocamlnet
    ocaml_pcre tyxml xml-light
  ];

  configureFlags = [ "--root $(out)" "--prefix /" ];

  dontAddPrefix = true;

  createFindlibDestdir = true;

  postFixup =
  ''
  rm -rf $out/var/run
  wrapProgram $out/bin/ocsigenserver \
    --suffix CAML_LD_LIBRARY_PATH : "${mkpath ssl "ssl"}:${mkpath ocamlnet "netsys"}:${mkpath ocamlnet "netstring"}:${mkpath ocaml_pcre "pcre"}:${mkpath ocaml_sqlite3 "sqlite3"}"
  '';

  dontPatchShebangs = true;

  meta = {
    homepage = "http://ocsigen.org/ocsigenserver/";
    description = "A full featured Web server";
    longDescription =''
      A full featured Web server. It implements most features of the HTTP protocol, and has a very powerful extension mechanism that make very easy to plug your own OCaml modules for generating pages.
      '';
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };

}
