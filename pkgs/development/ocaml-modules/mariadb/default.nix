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
  version = "2.2.1";

  src = fetchurl {
    url = "https://github.com/ocaml-community/ocaml-mariadb/releases/download/v${finalAttrs.version}/mariadb-v${finalAttrs.version}.tbz";
    hash = "sha256-ztKZMrfdD3tncRGYtVlx58kmlyj1NBhaBk/sLSdYPy0=";
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
