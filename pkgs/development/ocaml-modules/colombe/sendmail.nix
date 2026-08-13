{
  alcotest,
  angstrom,
  base64,
  buildDunePackage,
  colombe,
  hxd,
  ke,
  lib,
  logs,
  mrmime,
  rresult,
  tls,
}:

buildDunePackage {
  pname = "sendmail";
  inherit (colombe) version src;
  propagatedBuildInputs = [
    base64
    colombe
    logs
    rresult
    hxd
    ke
    tls
  ];
  doCheck = true;
  checkInputs = [
    alcotest
    mrmime
  ];
  meta = colombe.meta // {
    description = "Library to be able to send an email";
  };
}
