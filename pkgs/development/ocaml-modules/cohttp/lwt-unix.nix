{ lib, buildDunePackage, cohttp-lwt
, conduit-lwt-unix, conduit-lwt, ppx_sexp_conv
, cmdliner, fmt, logs, magic-mime
, ounit
, cacert
}:

buildDunePackage {
  pname = "cohttp-lwt-unix";
  inherit (cohttp-lwt) version src;

  duneVersion = "3";

  buildInputs = [ cmdliner ppx_sexp_conv ];

  propagatedBuildInputs = [
    cohttp-lwt conduit-lwt conduit-lwt-unix fmt logs magic-mime
  ];

  # TODO(@sternenseemann): fail for unknown reason
  # https://github.com/mirage/ocaml-cohttp/issues/675#issuecomment-830692742
  doCheck = false;
  nativeCheckInputs = [ ounit cacert ];

  meta = cohttp-lwt.meta // {
    description = "CoHTTP implementation for Unix and Windows using Lwt";
  };
}
