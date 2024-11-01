{ lib, buildDunePackage, ocaml, fetchurl, fmt, alcotest, crowbar, astring }:

buildDunePackage rec {
  pname = "pecu";
  version = "0.7";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/pecu/releases/download/v${version}/pecu-${version}.tbz";
    hash = "sha256-rXR3tbFkKNM8MkQAZ2hJU9lO+qQ/qvYghXkYus6f13g=";
  };

  # crowbar availability
  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ fmt alcotest crowbar astring ];

  meta = with lib; {
    description = "Encoder/Decoder of Quoted-Printable (RFC2045 & RFC2047)";
    license = licenses.mit;
    homepage = "https://github.com/mirage/pecu";
    maintainers = [ maintainers.sternenseemann ];
  };
}
