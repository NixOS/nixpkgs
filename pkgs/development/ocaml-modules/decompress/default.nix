{ lib, fetchurl, buildDunePackage
, checkseum, bigarray-compat, optint
, bigstringaf, alcotest, hxd, camlzip, base64
}:

buildDunePackage rec {
  version = "1.2.0";
  pname = "decompress";

  minimumOCamlVersion = "4.07";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/decompress/releases/download/v${version}/decompress-v${version}.tbz";
    sha256 = "1c3sq9a6kpzl0pj3gmg7w18ssjjl70yv0r3l7qjprcncjx23v62i";
  };

  propagatedBuildInputs = [ optint bigarray-compat checkseum ];
  checkInputs = [ alcotest bigstringaf hxd camlzip base64 ];
  doCheck = true;

  meta = {
    description = "Pure OCaml implementation of Zlib";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/decompress";
  };
}
