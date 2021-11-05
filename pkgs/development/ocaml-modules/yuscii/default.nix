{ alcotest
, buildDunePackage
, fetchzip
, fmt
, lib
, uutf
}:

buildDunePackage rec {
  pname = "yuscii";
  version = "0.3.0";

  src = fetchzip {
    url = "https://github.com/mirage/yuscii/releases/download/v${version}/yuscii-v${version}.tbz";
    sha256 = "0idywlkw0fbakrxv65swnr5bj7f2vns9kpay7q03gzlv82p670hy";
  };

  useDune2 = true;

  checkInputs = [
    alcotest
    fmt
    uutf
  ];
  doCheck = true;

  meta = {
    description = "A simple mapper between UTF-7 to Unicode according RFC2152";
    license = lib.licenses.mit;
    homepage = "https://github.com/mirage/yuscii";
    maintainers = with lib.maintainers; [ ];
  };
}
