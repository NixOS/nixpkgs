{
  lib,
  fetchurl,
  buildDunePackage,
  ctypes,
  mariadb,
  libmysqlclient,
  dune-configurator,
}:

buildDunePackage (finalAttrs: {
  pname = "mariadb";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/ocaml-community/ocaml-mariadb/releases/download/${finalAttrs.version}/mariadb-${finalAttrs.version}.tbz";
    hash = "sha256-mYktFTUDaA///SzTMgQDNXtYiXxnkMrf4EujijpmjMY=";
  };

  buildInputs = [
    mariadb
    libmysqlclient
    dune-configurator
  ];

  propagatedBuildInputs = [ ctypes ];

  meta = {
    description = "OCaml bindings for MariaDB";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://github.com/ocaml-community/ocaml-mariadb";
  };
})
