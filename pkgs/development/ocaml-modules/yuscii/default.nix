{ alcotest
, buildDunePackage
, ocaml
, fetchzip
, gcc
, fmt
, lib
, uutf
}:

buildDunePackage rec {
  pname = "yuscii";
  version = "0.3.0";

  minimalOCamlVersion = "4.03";

  src = fetchzip {
    url = "https://github.com/mirage/yuscii/releases/download/v${version}/yuscii-v${version}.tbz";
    sha256 = "0idywlkw0fbakrxv65swnr5bj7f2vns9kpay7q03gzlv82p670hy";
  };

  useDune2 = true;

  nativeCheckInputs = [
    gcc
    alcotest
    fmt
    uutf
  ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "A simple mapper between UTF-7 to Unicode according RFC2152";
    license = lib.licenses.mit;
    homepage = "https://github.com/mirage/yuscii";
    maintainers = with lib.maintainers; [ ];
  };
}
