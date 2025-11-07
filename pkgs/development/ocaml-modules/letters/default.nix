{
  alcotest-lwt,
  buildDunePackage,
  ca-certs,
  colombe,
  containers,
  domain-name,
  emile,
  fetchFromGitHub,
  fmt,
  lib,
  logs,
  lwt,
  mrmime,
  ptime,
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
  src = fetchFromGitHub {
    owner = "oxidizing";
    repo = "letters";
    tag = version;
    hash = "sha256-75uLg+0AVDNdQ0M4w8H7MrTYwAKMhe8R5xC4vPNGkuQ=";
  };
  propagatedBuildInputs = [
    ca-certs
    colombe
    containers
    domain-name
    emile
    fmt
    logs
    lwt
    mrmime
    ptime
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
