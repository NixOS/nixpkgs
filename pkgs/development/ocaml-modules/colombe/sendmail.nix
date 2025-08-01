{
  alcotest,
  angstrom,
  buildDunePackage,
  colombe,
  hxd,
  ke,
  lib,
  mrmime,
  rresult,
  tls,
}:

buildDunePackage {
  pname = "sendmail";
  inherit (colombe) version src;
  propagatedBuildInputs = [ hxd ];
  buildInputs = [
    angstrom
    colombe
    ke
    rresult
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
