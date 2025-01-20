{
  lib,
  buildDunePackage,
  fetchurl,
  angstrom-lwt-unix,
  lwt,
  logs,
  lwt_ppx,
  ppx_deriving_yojson,
  ppx_expect,
  ppx_here,
  react,
}:

buildDunePackage rec {
  pname = "dap";
  version = "1.0.6";
  duneVersion = "3";
  src = fetchurl {
    url = "https://github.com/hackwaly/ocaml-dap/releases/download/${version}/dap-${version}.tbz";
    sha256 = "1zq0f8429m38a4x3h9n3rv7n1vsfjbs72pfi5902a89qwyilkcp0";
  };

  minimalOCamlVersion = "4.08";

  buildInputs = [
    lwt_ppx
  ];

  propagatedBuildInputs = [
    angstrom-lwt-unix
    logs
    lwt
    ppx_deriving_yojson
    ppx_expect
    ppx_here
    react
  ];

  meta = {
    description = "Debug adapter protocol";
    homepage = "https://github.com/hackwaly/ocaml-dap";
    license = lib.licenses.mit;
  };
}
