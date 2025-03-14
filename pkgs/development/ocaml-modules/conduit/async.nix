{
  buildDunePackage,
  async,
  ppx_sexp_conv,
  ppx_here,
  uri,
  conduit,
  core,
  ipaddr,
  ipaddr-sexp,
  sexplib0,
}:

buildDunePackage {
  pname = "conduit-async";
  inherit (conduit)
    version
    src
    ;

  buildInputs = [
    ppx_sexp_conv
    ppx_here
  ];

  propagatedBuildInputs = [
    async
    conduit
    uri
    ipaddr
    ipaddr-sexp
    core
    sexplib0
  ];

  meta = conduit.meta // {
    description = "Network connection establishment library for Async";
  };
}
