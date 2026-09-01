{
  lib,
  fetchurl,
  sqlite,
  pkg-config,
  buildDunePackage,
  dune-configurator,
}:

buildDunePackage (finalAttrs: {
  pname = "sqlite3";
  version = "5.4.2";
  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/${finalAttrs.version}/sqlite3-${finalAttrs.version}.tbz";
    hash = "sha256-MvaPB49L6u1R68J5/vRhRSBf2Yz2x5/pVSGGAfICYhw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dune-configurator
    sqlite
  ];

  meta = {
    homepage = "http://mmottl.github.io/sqlite3-ocaml/";
    description = "OCaml bindings to the SQLite 3 database access library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vbgl
    ];
  };
})
