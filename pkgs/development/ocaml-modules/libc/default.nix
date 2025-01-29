{
  lib,
  buildDunePackage,
  fetchurl,
  config,
}:

buildDunePackage rec {
  pname = "libc";
  version = "0.0.1";

  src = fetchurl {
    url = "https://github.com/ocaml-sys/libc.ml/releases/download/${version}/libc-${version}.tbz";
    hash = "sha256-e5x5Yae7V6qOpq+aLZaV+6L9ldy9qDqd9Kc8nkAsENg=";
  };

  buildInputs = [
    config
  ];

  meta = {
    description = "Raw definitions and bindings to platforms system libraries";
    homepage = "https://github.com/ocaml-sys/libc.ml";
    license = lib.licenses.mit;
  };
}
