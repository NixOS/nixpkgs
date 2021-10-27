{ alcotest
, angstrom
, bigstringaf
, buildDunePackage
, crowbar
, fetchzip
, fmt
, hxd
, ke
, lib
, rresult
, uutf
}:

buildDunePackage rec {
  pname = "unstrctrd";
  version = "0.3";

  src = fetchzip {
    url = "https://github.com/dinosaure/unstrctrd/releases/download/v${version}/unstrctrd-v${version}.tbz";
    sha256 = "0mjm4v7kk75iwwsfnpmxc3bsl8aisz53y7z21sykdp60f4rxnah7";
  };

  useDune2 = true;

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
    description = "A library for parsing email headers";
    homepage = "https://github.com/dinosaure/unstrctrd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ superherointj ];
  };
}
