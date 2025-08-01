{
  alcotest,
  angstrom,
  buildDunePackage,
  crowbar,
  emile,
  fetchFromGitHub,
  fmt,
  ipaddr,
  lib,
}:

let
  pname = "colombe";
  version = "0.12.0";
in
buildDunePackage {
  inherit pname version;
  minimalOCamlVersion = "4.03";
  src = fetchFromGitHub {
    owner = "mirage";
    repo = "colombe";
    tag = "v${version}";
    hash = "sha256-5uP1yTZgG8SbGIZID/xbuOs6I93toFeI6Fk1IZX4ptw=";
  };
  buildInputs = [
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
