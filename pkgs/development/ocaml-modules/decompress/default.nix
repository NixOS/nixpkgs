{ lib, fetchurl, buildDunePackage
, checkseum, bigarray-compat, optint, cmdliner
, bigstringaf, alcotest, camlzip, base64, ctypes, fmt
}:

buildDunePackage rec {
  version = "1.3.0";
  pname = "decompress";

  minimumOCamlVersion = "4.07";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/decompress/releases/download/v${version}/decompress-v${version}.tbz";
    sha256 = "de149896939be13fedec46a4581121d5ab74850a2241d08e6aa8ae4bb18c52c4";
  };

  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ optint bigarray-compat checkseum ];
  checkInputs = [ alcotest bigstringaf ctypes fmt camlzip base64 ];
  doCheck = true;

  meta = {
    description = "Pure OCaml implementation of Zlib";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/decompress";
  };
}
