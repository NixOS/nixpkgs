{ buildDunePackage, cohttp, cohttp-lwt
, mirage-flow, mirage-channel, mirage-kv
, conduit, conduit-mirage, lwt
, astring, magic-mime
, ppx_sexp_conv
}:

buildDunePackage {
  pname = "cohttp-mirage";

  inherit (cohttp) version src;

  nativeBuildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    mirage-flow mirage-channel conduit conduit-mirage mirage-kv
    lwt cohttp cohttp-lwt astring magic-mime
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation for the MirageOS unikernel";
  };
}
