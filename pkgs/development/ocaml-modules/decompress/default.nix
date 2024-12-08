{ lib, fetchurl, buildDunePackage
, checkseum, optint, cmdliner
, bigstringaf, alcotest, camlzip, base64, ctypes, fmt, crowbar, rresult
, astring, bos
}:

buildDunePackage rec {
  pname = "decompress";
  version = "1.5.3";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/decompress/releases/download/v${version}/decompress-${version}.tbz";
    hash = "sha256-+R5peL7/P8thRA0y98mcmfHoZUtPsYQIdB02A1NzrGA=";
  };

  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ optint checkseum ];
  checkInputs = [ alcotest astring bigstringaf bos ctypes fmt camlzip base64 crowbar rresult ];
  doCheck = true;

  meta = {
    description = "Pure OCaml implementation of Zlib";
    homepage = "https://github.com/mirage/decompress";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "decompress.pipe";
  };
}
