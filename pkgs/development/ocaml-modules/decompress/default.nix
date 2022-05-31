{ lib, fetchurl, buildDunePackage
, checkseum, optint, cmdliner_1_1
, bigstringaf, alcotest, camlzip, base64, ctypes, fmt
}:

buildDunePackage rec {
  version = "1.4.3";
  pname = "decompress";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/decompress/releases/download/v${version}/decompress-${version}.tbz";
    sha256 = "sha256-siJUrl63dHRSJn/JdqOgukCMWv2uCJbKxAaLTXntWj0=";
  };

  buildInputs = [ cmdliner_1_1 ];
  propagatedBuildInputs = [ optint checkseum ];
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
