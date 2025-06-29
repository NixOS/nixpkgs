{
  lib,
  fetchurl,
  buildDunePackage,
  angstrom,
  bigstringaf,
  domain-name,
  dune-site,
  ipaddr,
  logs,
  lru,
  lwt-dllist,
  mtime,
  ptime,
  uri,
  stdenv,
  darwin,
}:

buildDunePackage rec {
  pname = "caqti";
  version = "2.2.4";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/paurkedal/ocaml-caqti/releases/download/v${version}/caqti-v${version}.tbz";
    hash = "sha256-uOpDKCAVTsCVEyxPeyRLBs2FU+CyA1GFuETZxPMK+Ls=";
  };

  buildInputs = [ dune-site ];
  propagatedBuildInputs = [
    angstrom
    bigstringaf
    domain-name
    ipaddr
    logs
    lru
    lwt-dllist
    mtime
    ptime
    uri
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.sigtool ];

  # Checks depend on caqti-driver-sqlite3 (circural dependency)
  doCheck = false;

  meta = {
    description = "Unified interface to relational database libraries";
    license = with lib.licenses; [
      lgpl3Plus
      ocamlLgplLinkingException
    ];
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://github.com/paurkedal/ocaml-caqti";
  };
}
