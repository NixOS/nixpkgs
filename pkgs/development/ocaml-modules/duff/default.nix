{ lib, fetchurl, buildDunePackage, fetchpatch
, stdlib-shims, bigarray-compat, fmt
, alcotest, hxd, crowbar, bigstringaf
}:

buildDunePackage rec {
  pname = "duff";
  version = "0.4";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/duff/releases/download/v${version}/duff-v${version}.tbz";
    sha256 = "4795e8344a2c2562e0ef6c44ab742334b5cd807637354715889741b20a461da4";
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
