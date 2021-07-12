{ lib, buildDunePackage, fetchurl
, ppx_cstruct, ppx_sexp_conv, ounit, io-page-unix
, lwt, cstruct, io-page, mirage-flow, xenstore, xenstore_transport
, sexplib, cmdliner
}:

buildDunePackage rec {
  pname = "vchan";
  version = "6.0.0";

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-vchan/releases/download/v${version}/vchan-v${version}.tbz";
    sha256 = "7a6cc89ff8ba7144d6cef3f36722f40deedb3cefff0f7be1b2f3b7b2a2b41747";
  };

  nativeBuildInputs = [
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    ppx_sexp_conv
    lwt
    cstruct
    io-page
    mirage-flow
    xenstore
    xenstore_transport
    sexplib
  ];

  doCheck = true;
  checkInputs = [
    cmdliner
    io-page-unix
    ounit
  ];

  meta = with lib; {
    description = "Xen Vchan implementation";
    homepage = "https://github.com/mirage/ocaml-vchan";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
