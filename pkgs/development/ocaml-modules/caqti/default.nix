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
  lwt-dllist,
  mtime,
  ptime,
  uri,
}:

buildDunePackage rec {
  pname = "caqti";
  version = "2.1.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/paurkedal/ocaml-caqti/releases/download/v${version}/caqti-v${version}.tbz";
    hash = "sha256-SDpTX0HiZBkX/BgyzkrRX/w/ToKDsbMBiiYXNJWDCQo=";
  };

  buildInputs = [ dune-site ];
  propagatedBuildInputs = [
    angstrom
    bigstringaf
    domain-name
    ipaddr
    logs
    lwt-dllist
    mtime
    ptime
    uri
  ];

  # Checks depend on caqti-driver-sqlite3 (circural dependency)
  doCheck = false;

  meta = with lib; {
    description = "Unified interface to relational database libraries";
    license = with licenses; [
      lgpl3Plus
      ocamlLgplLinkingException
    ];
    maintainers = with maintainers; [ bcc32 ];
    homepage = "https://github.com/paurkedal/ocaml-caqti";
  };
}
