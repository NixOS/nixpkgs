{
  alcotest-lwt,
  buildDunePackage,
  ca-certs,
  colombe,
  containers,
  fetchFromGitHub,
  lib,
  mrmime,
  rresult,
  sendmail,
  tls-lwt,
  x509,
}:

let
  pname = "letters";
  version = "0.4.0";
in
buildDunePackage {
  inherit pname version;
  minimalOCamlVersion = "4.03";
  src = fetchFromGitHub {
    owner = "oxidizing";
    repo = "letters";
    tag = version;
    hash = "sha256-75uLg+0AVDNdQ0M4w8H7MrTYwAKMhe8R5xC4vPNGkuQ=";
  };
  buildInputs = [
    ca-certs
    colombe
    containers
    mrmime
    rresult
    sendmail
    tls-lwt
    x509
  ];
  doCheck = true;
  checkInputs = [ alcotest-lwt ];
  meta = {
    description = "OCaml library for creating and sending emails over SMTP using LWT";
    homepage = "https://github.com/oxidizing/letters";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vog ];
  };
}
