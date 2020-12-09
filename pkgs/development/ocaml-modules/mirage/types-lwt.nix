{ lib, buildDunePackage, mirage-types
}:

buildDunePackage {
  pname = "mirage-types-lwt";
  inherit (mirage-types) version src useDune2;

  propagatedBuildInputs = [ mirage-types ];

  meta = mirage-types.meta // {
    description = "Lwt module type definitions for MirageOS applications";
  };
}
