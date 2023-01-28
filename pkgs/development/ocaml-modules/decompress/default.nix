{ lib, fetchurl, buildDunePackage
, checkseum, optint, cmdliner
, bigstringaf, alcotest, camlzip, base64, ctypes, fmt, crowbar, rresult
}:

buildDunePackage rec {
  pname = "decompress";
  version = "1.5.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/decompress/releases/download/v${version}/decompress-${version}.tbz";
    sha256 = "sha256-y/OVojFxhksJQQvvtS38SF7ZnMEQhAtwDey0ISwypP4=";
  };

  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ optint checkseum ];
  nativeCheckInputs = [ alcotest bigstringaf ctypes fmt camlzip base64 crowbar rresult ];
  doCheck = true;

  meta = {
    description = "Pure OCaml implementation of Zlib";
    homepage = "https://github.com/mirage/decompress";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "decompress.pipe";
  };
}
