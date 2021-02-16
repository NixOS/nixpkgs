{ lib, fetchurl, buildDunePackage
, stdlib-shims, bigarray-compat, fmt
, alcotest, hxd, crowbar, bigstringaf
}:

buildDunePackage rec {
  pname = "duff";
  version = "0.3";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/duff/releases/download/v${version}/duff-v${version}.tbz";
    sha256 = "1lb67yxk93ifj94p1i3swjbnj5xy8j6xzs72bwvq6cffx5xykznm";
  };

  propagatedBuildInputs = [ stdlib-shims bigarray-compat fmt ];

  doCheck = true;
  checkInputs = [
    alcotest
    crowbar
    hxd
    bigstringaf
  ];


  meta = {
    description = "Pure OCaml implementation of libXdiff (Rabin’s fingerprint)";
    homepage = "https://github.com/mirage/duff";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
