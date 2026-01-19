{
  lib,
  fetchurl,
  buildDunePackage,
  pkg-config,
  dune-configurator,
  libpq,
}:

buildDunePackage rec {
  pname = "postgresql";
  version = "5.2.0";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/mmottl/postgresql-ocaml/releases/download/${version}/postgresql-${version}.tbz";
    hash = "sha256-uU/K7hvQljGnUzClPRdod32tpVAGd/sGqh3NqIygJ4A=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libpq ];

  meta = {
    description = "Bindings to the PostgreSQL library";
    license = lib.licenses.lgpl21Plus;
    changelog = "https://raw.githubusercontent.com/mmottl/postgresql-ocaml/refs/tags/${version}/CHANGES.md";
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://mmottl.github.io/postgresql-ocaml";
  };
}
