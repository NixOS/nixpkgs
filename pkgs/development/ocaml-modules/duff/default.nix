{ lib, fetchurl, buildDunePackage, fetchpatch
, stdlib-shims, bigarray-compat, fmt
, alcotest, hxd, crowbar, bigstringaf
}:

buildDunePackage rec {
  pname = "duff";
  version = "0.5";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/duff/releases/download/v${version}/duff-${version}.tbz";
    sha256 = "sha256-0eqpfPWNOHYjkcjXRnZUTUFF0/L9E+TNoOqKCETN5hI=";
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
