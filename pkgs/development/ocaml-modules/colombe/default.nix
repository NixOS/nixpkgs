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
  version = "0.13.1";
in
buildDunePackage {
  inherit pname version;
  minimalOCamlVersion = "4.03";
  src = fetchurl {
    url = "https://github.com/mirage/colombe/releases/download/v${version}/colombe-${version}.tbz";
    hash = "sha256-3fWcyj4GNw1qgw9Ggp3lGPKfHPpgerT5+5bmI/CMyQY=";
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
