{ lib
, buildDunePackage
, netchannel
, ppx_sexp_conv
, lwt
, cstruct
, mirage-net
, mirage-xen
, io-page
, lwt-dllist
, logs
}:

buildDunePackage {
  pname = "mirage-net-xen";

  inherit (netchannel)
    src
    version
    useDune2
    minimumOCamlVersion
    meta
    ;

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
