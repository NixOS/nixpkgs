{ lib, fetchurl, buildDunePackage
, checkseum, bigarray-compat, optint, cmdliner
, bigstringaf, alcotest, camlzip, base64, ctypes, fmt
}:

buildDunePackage rec {
  version = "1.4.1";
  pname = "decompress";

  minimumOCamlVersion = "4.07";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/decompress/releases/download/v${version}/decompress-v${version}.tbz";
    sha256 = "0130ea6acb61b0a25393fa23148e116d7a17c77558196f7abddaee9e05a1d7a8";
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
