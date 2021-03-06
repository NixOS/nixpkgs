{ lib, fetchurl, buildDunePackage, fetchpatch
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

  patches = [
    # compatibility with hxd >= 0.3.0
    (fetchpatch {
      url = "https://github.com/mirage/duff/commit/da0737975aaca313ee4ad9f1e46db1e969672a5b.patch";
      sha256 = "0qbqzfn2rv867fjcd607cjbnvrfh8fzxlp9mn5r7jx5v83l0zjjq";
    })
  ];

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
