{
  alcotest,
  angstrom,
  bigstringaf,
  buildDunePackage,
  crowbar,
  fetchzip,
  fmt,
  hxd,
  ke,
  lib,
  rresult,
  uutf,
}:

buildDunePackage rec {
  pname = "unstrctrd";
  version = "0.5";

  src = fetchzip {
    url = "https://github.com/dinosaure/unstrctrd/releases/download/v${version}/unstrctrd-${version}.tbz";
    hash = "sha256-WmjFDxgFTkOmHwcy+9aXBz688DvBBqSeevl2K3/Sv9Y=";
  };

  propagatedBuildInputs = [
    angstrom
    uutf
  ];

  checkInputs = [
    alcotest
    bigstringaf
    crowbar
    fmt
    hxd
    ke
    rresult
  ];
  doCheck = true;

  meta = {
    description = "Library for parsing email headers";
    homepage = "https://github.com/dinosaure/unstrctrd";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
