{ lib, buildDunePackage, fetchurl
, ppx_cstruct, ppx_sexp_conv, ounit
, lwt, cstruct, io-page, mirage-flow, xenstore, xenstore_transport
, sexplib, cmdliner
}:

buildDunePackage rec {
  pname = "vchan";
  version = "6.0.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-vchan/releases/download/v${version}/vchan-${version}.tbz";
    sha256 = "sha256-5E7dITMVirYoxUkp8ZamRAolyhA6avXGJNAioxeBuV0=";
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
  nativeCheckInputs = [
    cmdliner
    ounit
  ];

  meta = with lib; {
    description = "Xen Vchan implementation";
    homepage = "https://github.com/mirage/ocaml-vchan";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
