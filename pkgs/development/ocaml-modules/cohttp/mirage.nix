{ buildDunePackage, cohttp, cohttp-lwt
, mirage-flow, mirage-channel, mirage-kv
, conduit, conduit-mirage, lwt
, astring, magic-mime
}:

buildDunePackage {
  pname = "cohttp-mirage";

  inherit (cohttp) version src minimumOCamlVersion useDune2;

  propagatedBuildInputs = [
    mirage-flow mirage-channel conduit conduit-mirage mirage-kv
    lwt cohttp cohttp-lwt astring magic-mime
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation for the MirageOS unikernel";
  };
}
