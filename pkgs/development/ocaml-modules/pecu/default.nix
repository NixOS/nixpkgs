{ lib, buildDunePackage, ocaml, fetchurl, fmt, alcotest, crowbar, astring }:

buildDunePackage rec {
  pname = "pecu";
  version = "0.6";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/pecu/releases/download/v${version}/pecu-v${version}.tbz";
    sha256 = "a9d2b7da444c83b20f879f6c3b7fc911d08ac1e6245ad7105437504f9394e5c7";
  };

  # crowbar availability
  doCheck = lib.versionAtLeast ocaml.version "4.08";
  nativeCheckInputs = [ fmt alcotest crowbar astring ];

  meta = with lib; {
    description = "Encoder/Decoder of Quoted-Printable (RFC2045 & RFC2047)";
    license = licenses.mit;
    homepage = "https://github.com/mirage/pecu";
    maintainers = [ maintainers.sternenseemann ];
  };
}
