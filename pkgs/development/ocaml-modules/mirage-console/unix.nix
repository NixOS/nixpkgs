{ buildDunePackage, mirage-console, lwt, cstruct, cstruct-lwt }:

buildDunePackage {
  pname = "mirage-console-unix";

  inherit (mirage-console) version src;

  propagatedBuildInputs = [
    mirage-console
    cstruct
    cstruct-lwt
  ];

  meta = mirage-console.meta // {
    description = "Implementation of Mirage consoles for Unix";
  };
}
