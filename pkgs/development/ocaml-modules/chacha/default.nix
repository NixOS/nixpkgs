{ lib
, buildDunePackage
, fetchurl
, ocaml

, alcotest
, cstruct
, mirage-crypto
}:

buildDunePackage rec {
  pname = "chacha";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/abeaumont/ocaml-chacha/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "sha256-t8dOMQQDpje0QbuOhjSIa3xnXuXcxMVTLENa/rwdgA4=";
  };

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  propagatedBuildInputs = [ cstruct mirage-crypto ];

  # alcotest isn't available for OCaml < 4.05 due to fmt
  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/abeaumont/ocaml-chacha";
    description = "ChaCha20, ChaCha12 and ChaCha8 encryption functions, in OCaml";
    longDescription = ''
      An OCaml implementation of ChaCha functions, both ChaCha20 and the reduced
      ChaCha8 and ChaCha12 functions. The hot loop is implemented in C for efficiency
      reasons.
    '';
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
