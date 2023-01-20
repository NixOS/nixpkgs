{ lib, fetchurl, buildDunePackage, ocaml
, checkseum, bigarray-compat, optint, cmdliner
, bigstringaf, alcotest, camlzip, base64, ctypes, fmt
}:

buildDunePackage rec {
  version = "1.4.2";
  pname = "decompress";

  minimumOCamlVersion = "4.07";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/decompress/releases/download/v${version}/decompress-v${version}.tbz";
    sha256 = "822f125b46c87f4a902c334db8c86d4d5f33ebe978e93c40351a4d3269b95225";
  };

  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ optint bigarray-compat checkseum ];
  checkInputs = [ alcotest bigstringaf ctypes fmt camlzip base64 ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "Pure OCaml implementation of Zlib";
    homepage = "https://github.com/mirage/decompress";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "decompress.pipe";
  };
}
