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
  version = "5.3.2";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/mmottl/postgresql-ocaml/releases/download/${version}/postgresql-${version}.tbz";
    hash = "sha256-HEfSJ3L4k4/yPXNQV12I/yo88NHzmIFi97uAe8yxV68=";
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
