{
  buildDunePackage,
  raylib,
}:

buildDunePackage {
  pname = "raygui";

  inherit (raylib) src version;

  propagatedBuildInputs = [
    raylib
  ];

  meta = raylib.meta // {
    description = "OCaml bindings for raygui";
  };
}
