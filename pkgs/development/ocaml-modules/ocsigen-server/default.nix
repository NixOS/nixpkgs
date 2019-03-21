{ stdenv, fetchFromGitHub, which, ocaml, findlib, lwt_react, ssl, lwt_ssl
, lwt_log, ocamlnet, ocaml_pcre, cryptokit, tyxml, xml-light, ipaddr
, pgocaml, camlzip, ocaml_sqlite3
, makeWrapper
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "ocsigenserver is not available for OCaml ${ocaml.version}"
else

let mkpath = p: n:
  "${p}/lib/ocaml/${ocaml.version}/site-lib/${n}";
in

stdenv.mkDerivation rec {
  version = "2.11.0";
  name = "ocsigenserver-${version}";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigenserver";
    rev = version;
    sha256 = "0y1ngki7w9s10ip7nj9qb7254bd5sp01xxz16sxyj7l7qz603hy2";
  };

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
    --prefix CAML_LD_LIBRARY_PATH : "${mkpath ssl "ssl"}:${mkpath ocamlnet "netsys"}:${mkpath ocamlnet "netstring"}:${mkpath ocaml_pcre "pcre"}:${mkpath cryptokit "cryptokit"}:${mkpath ocaml_sqlite3 "sqlite3"}"
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
