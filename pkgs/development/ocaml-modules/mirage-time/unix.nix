{ buildDunePackage, fetchurl, mirage-time, ocaml_lwt, duration }:

buildDunePackage {
  pname = "mirage-time-unix";

  inherit (mirage-time) src useDune2 version minimumOCamlVersion;

  propagatedBuildInputs = [ mirage-time ocaml_lwt duration ];

  meta = mirage-time.meta // {
    description = "Time operations for MirageOS on Unix";
  };
}
