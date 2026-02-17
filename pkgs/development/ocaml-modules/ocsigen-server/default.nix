{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  which,
  ocaml,
  lwt_react,
  ssl,
  lwt_ssl,
  findlib,
  bigstringaf,
  lwt,
  cstruct,
  mirage-crypto,
  zarith,
  mirage-crypto-ec,
  ptime,
  mirage-crypto-rng,
  mtime,
  ca-certs,
  cohttp,
  cohttp-lwt-unix,
  lwt_log,
  re,
  logs-syslog,
  cryptokit,
  xml-light,
  ipaddr,
  camlzip,
  makeWrapper,
}:

let
  mkpath = p: "${p}/lib/ocaml/${ocaml.version}/site-lib/stublibs";
in

let
  caml_ld_library_path = lib.concatMapStringsSep ":" mkpath [
    bigstringaf
    lwt
    ssl
    cstruct
    mirage-crypto
    zarith
    mirage-crypto-ec
    ptime
    mirage-crypto-rng
    mtime
    ca-certs
    cryptokit
    re
  ];
in

buildDunePackage {
  version = "6.0.0-unstable-2025-08-11";
  pname = "ocsigenserver";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigenserver";
    rev = "0d3c74d71fbdf738d1e45a98814b7ebdd1efe6c1";
    hash = "sha256-KEHTw4cCPRJSE4SAnUFWzeoiEz8y9nUQFpaFiNxAsiU=";
  };

  nativeBuildInputs = [
    makeWrapper
    which
  ];
  buildInputs = [
    lwt_react
    camlzip
    findlib
  ];

  propagatedBuildInputs = [
    cohttp
    cohttp-lwt-unix
    cryptokit
    ipaddr
    lwt_log
    lwt_ssl
    re
    logs-syslog
    xml-light
  ];

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  postInstall = ''
    make install.files
  '';

  postFixup = ''
    rm -rf $out/var/run
    wrapProgram $out/bin/ocsigenserver \
      --suffix CAML_LD_LIBRARY_PATH : "${caml_ld_library_path}"
  '';

  dontPatchShebangs = true;

  meta = {
    homepage = "http://ocsigen.org/ocsigenserver/";
    description = "Full featured Web server";
    longDescription = ''
      A full featured Web server. It implements most features of the HTTP protocol, and has a very powerful extension mechanism that make very easy to plug your own OCaml modules for generating pages.
    '';
    license = lib.licenses.lgpl21Only;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.gal_bolle ];
  };

}
