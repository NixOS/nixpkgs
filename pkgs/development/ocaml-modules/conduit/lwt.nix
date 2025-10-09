{
  buildDunePackage,
  ppx_sexp_conv,
  conduit,
  lwt,
  sexplib0,
}:

buildDunePackage {
  pname = "conduit-lwt";
  inherit (conduit) version src;

  buildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    conduit
    lwt
    sexplib0
  ];

  meta = conduit.meta // {
    description = "Network connection establishment library for Lwt";
  };
}
