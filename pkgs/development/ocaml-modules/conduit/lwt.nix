{
  buildDunePackage,
  ppx_sexp_conv,
  conduit,
  lwt,
  sexplib,
}:

buildDunePackage {
  pname = "conduit-lwt";
  inherit (conduit) version src;

  buildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    conduit
    lwt
    sexplib
  ];

  meta = conduit.meta // {
    description = "A network connection establishment library for Lwt";
  };
}
