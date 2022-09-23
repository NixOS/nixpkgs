{ lib
, buildDunePackage
, fetchFromGitHub
, fetchpatch
, ocaml

, alcotest
, cstruct
, mirage-crypto
}:

buildDunePackage rec {
  pname = "chacha";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "abeaumont";
    repo = "ocaml-chacha";
    rev = version;
    sha256 = "sha256-PmeiFloU0k3SqOK1VjaliiCEzDzrzyMSasgnO5fJS1k=";
  };

  # Ensure compatibility with cstruct ≥ 6.1.0
  patches = [ (fetchpatch {
    url = "https://github.com/abeaumont/ocaml-chacha/commit/fbe4a0a808226229728a68f278adf370251196fd.patch";
    sha256 = "sha256-y7X9toFDrgdv3qmFmUs7K7QS+Gy45rRLulKy48m7uqc=";
  })];

  minimalOCamlVersion = "4.02";

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
