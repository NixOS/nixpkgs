{ lib, buildDunePackage, fetchFromGitHub, which, ocaml, lwt_react, ssl, lwt_ssl, findlib
, bigstringaf, lwt, cstruct, mirage-crypto, zarith, mirage-crypto-ec, ptime, mirage-crypto-rng, mtime, ca-certs
, cohttp, cohttp-lwt-unix, hmap
, lwt_log, re, cryptokit, xml-light, ipaddr
, camlzip
, makeWrapper
}:

let mkpath = p:
  "${p}/lib/ocaml/${ocaml.version}/site-lib/stublibs";
in

let caml_ld_library_path =
  lib.concatMapStringsSep ":" mkpath [
    bigstringaf lwt ssl cstruct mirage-crypto zarith mirage-crypto-ec ptime mirage-crypto-rng mtime ca-certs cryptokit re
  ]
; in

buildDunePackage rec {
  version = "5.1.0";
  pname = "ocsigenserver";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigenserver";
    rev = "refs/tags/${version}";
    hash = "sha256-6xO+4eYSp6rlgPT09L7cvlaz6kYYuUPRa3K/TgZmaqE=";
  };

  nativeBuildInputs = [ makeWrapper which ];
  buildInputs = [ lwt_react camlzip findlib ];

  propagatedBuildInputs = [ cohttp cohttp-lwt-unix cryptokit hmap ipaddr lwt_log lwt_ssl
    re xml-light
  ];

  configureFlags = [ "--root $(out)" "--prefix /" "--temproot ''" ];

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  postConfigure = ''
    make -C src confs
  '';

  postInstall = ''
    make install.files
  '';

  postFixup =
  ''
  rm -rf $out/var/run
  wrapProgram $out/bin/ocsigenserver \
    --suffix CAML_LD_LIBRARY_PATH : "${caml_ld_library_path}"
  '';

  dontPatchShebangs = true;

  meta = {
    homepage = "http://ocsigen.org/ocsigenserver/";
    description = "A full featured Web server";
    longDescription =''
      A full featured Web server. It implements most features of the HTTP protocol, and has a very powerful extension mechanism that make very easy to plug your own OCaml modules for generating pages.
      '';
    license = lib.licenses.lgpl21Only;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.gal_bolle ];
  };

}
