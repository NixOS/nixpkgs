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

buildDunePackage (finalAttrs: {
  pname = "dap";
  version = "1.0.6";
  duneVersion = "3";
  src = fetchurl {
    url = "https://github.com/hackwaly/ocaml-dap/releases/download/${finalAttrs.version}/dap-${finalAttrs.version}.tbz";
    hash = "sha256-4LJJo+c4ISVAKtFdcfSSTu9gz87DJjg6UWjUJAhyAP8=";
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
})
