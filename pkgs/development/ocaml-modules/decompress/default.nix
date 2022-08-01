{ lib, fetchurl, buildDunePackage
, checkseum, bigarray-compat, optint, cmdliner_1_1
, bigstringaf, alcotest, camlzip, base64, ctypes, fmt
}:

buildDunePackage rec {
  version = "1.4.3";
  pname = "decompress";

  minimumOCamlVersion = "4.07";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/decompress/releases/download/v${version}/decompress-${version}.tbz";
    sha256 = "0gasxmwlv2q6qk59c25fzmd8qh5sl2ipdjbz4r978x5pbsp588mj";
  };

  buildInputs = [ cmdliner_1_1 ];
  propagatedBuildInputs = [ optint bigarray-compat checkseum ];
  checkInputs = [ alcotest bigstringaf ctypes fmt camlzip base64 ];
  doCheck = true;

  meta = {
    description = "Pure OCaml implementation of Zlib";
    homepage = "https://github.com/mirage/decompress";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "decompress.pipe";
  };
}
