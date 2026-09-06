{
  lib,
  buildDunePackage,
  ocaml,
  dune,
  csexp,
  version ? if lib.versionAtLeast ocaml.version "4.13" then dune.version else "3.22.2",
}:

buildDunePackage {
  pname = "dune-configurator";
  inherit version;

  inherit (dune.override { inherit version; }) src;

  dontAddPrefix = true;

  propagatedBuildInputs = [ csexp ];

  meta = {
    description = "Helper library for gathering system configuration";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
