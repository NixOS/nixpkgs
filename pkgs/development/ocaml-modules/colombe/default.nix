{
  alcotest,
  angstrom,
  buildDunePackage,
  crowbar,
  emile,
  fetchurl,
  fmt,
  ipaddr,
  lib,
}:

let
  pname = "colombe";
  version = "0.13.0";
in
buildDunePackage {
  inherit pname version;
  minimalOCamlVersion = "4.03";
  src = fetchurl {
    url = "https://github.com/mirage/colombe/releases/download/v${version}/colombe-${version}.tbz";
    hash = "sha256-PVW1uvdwVyOcHcCiiTBgMDgXxp9TnG+A0E+PHFBM8k0=";
  };
  propagatedBuildInputs = [
    angstrom
    emile
    fmt
    ipaddr
  ];
  doCheck = true;
  checkInputs = [
    alcotest
    crowbar
  ];
  meta = {
    description = "SMTP protocol according to RFC5321 without extensions";
    homepage = "https://github.com/mirage/colombe";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vog ];
  };
}
