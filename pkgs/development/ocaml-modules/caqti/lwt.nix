{ buildDunePackage, caqti, logs, lwt }:

buildDunePackage {
  pname = "caqti-lwt";
  inherit (caqti) version src;

  propagatedBuildInputs = [ caqti logs lwt ];

  meta = caqti.meta // { description = "Lwt support for Caqti"; };
}
