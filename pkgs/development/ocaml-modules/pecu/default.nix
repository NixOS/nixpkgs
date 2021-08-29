{ lib, buildDunePackage, ocaml, fetchurl, fmt, alcotest }:

buildDunePackage rec {
  pname = "pecu";
  version = "0.5";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/pecu/releases/download/v0.5/pecu-v0.5.tbz";
    sha256 = "713753cd6ba3f4609a26d94576484e83ffef7de5f2208a2993576a1b22f0e0e7";
  };

  # fmt availability
  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ fmt alcotest ];

  meta = with lib; {
    description = "Encoder/Decoder of Quoted-Printable (RFC2045 & RFC2047)";
    license = licenses.mit;
    homepage = "https://github.com/mirage/pecu";
    maintainers = [ maintainers.sternenseemann ];
  };
}
