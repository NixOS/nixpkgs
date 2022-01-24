{ buildDunePackage, irmin, mtime, logs, lwt }:

buildDunePackage {
  pname = "irmin-layers";

  inherit (irmin) version src useDune2;

  propagatedBuildInputs = [
    irmin
    mtime
    logs
    lwt
  ];

  meta = irmin.meta // {
    description = "Combine different Irmin stores into a single, layered store";
  };
}
