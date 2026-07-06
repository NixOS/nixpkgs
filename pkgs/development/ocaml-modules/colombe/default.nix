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
  version = "0.12.1";
in
buildDunePackage {
  inherit pname version;
  minimalOCamlVersion = "4.03";
  src = fetchurl {
    url = "https://github.com/mirage/colombe/releases/download/v${version}/colombe-${version}.tbz";
    hash = "sha256-6LHsxHUe5zGuNvgcIpJjg17gmx4QrKiO4UDIZcTB2CM=";
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
