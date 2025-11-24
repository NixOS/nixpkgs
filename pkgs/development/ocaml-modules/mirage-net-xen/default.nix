{
  buildDunePackage,
  netchannel,
  ppx_sexp_conv,
  lwt,
  cstruct,
  mirage-net,
  mirage-xen,
  io-page,
  lwt-dllist,
  logs,
}:

buildDunePackage {
  pname = "mirage-net-xen";

  inherit (netchannel)
    src
    version
    meta
    ;

  duneVersion = "3";

  nativeBuildInputs = [
    ppx_sexp_conv
  ];

  propagatedBuildInputs = [
    lwt
    cstruct
    netchannel
    mirage-net
    mirage-xen
    io-page
    lwt-dllist
    logs
  ];
}
