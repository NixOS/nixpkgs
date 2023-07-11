{ lib, buildDunePackage
, cohttp, cohttp-lwt, logs, lwt, js_of_ocaml, js_of_ocaml-ppx, js_of_ocaml-lwt
, nodejs, lwt_ppx
}:

buildDunePackage {
  pname = "cohttp-lwt-jsoo";
  inherit (cohttp-lwt) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    cohttp
    cohttp-lwt
    logs
    lwt
    js_of_ocaml
    js_of_ocaml-ppx
    js_of_ocaml-lwt
  ];

  doCheck = true;
  checkInputs = [
    nodejs
    lwt_ppx
  ];

  meta = cohttp-lwt.meta // {
    description = "CoHTTP implementation for the Js_of_ocaml JavaScript compiler";
  };
}
