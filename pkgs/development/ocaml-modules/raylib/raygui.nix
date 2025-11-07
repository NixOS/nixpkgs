{
  buildDunePackage,
  fetchurl,
  raylib,
}:

buildDunePackage rec {
  pname = "raygui";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/tjammer/raylib-ocaml/releases/download/${version}/raygui-${version}.tbz";
    hash = "sha256-PQcVTAQKeTPkOOHk5w3O3Tz0n7jLvkIo3Urvrk66eMs=";
  };

  inherit (raylib) patches;

  propagatedBuildInputs = [
    raylib
  ];

  meta = raylib.meta // {
    description = "OCaml bindings for raygui";
  };
}
