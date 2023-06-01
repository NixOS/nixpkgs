{ lib, fetchFromGitHub, buildDunePackage
, stdlib-shims
}:

buildDunePackage rec {
  pname = "integers";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ocamllabs";
    repo = "ocaml-integers";
    rev = version;
    sha256 = "sha256-zuUgP1jOiVT0q6GisGpkqx7nybWbARgnAcU8NYqvCzA=";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = {
    description = "Various signed and unsigned integer types for OCaml";
    license = lib.licenses.mit;
    homepage = "https://github.com/ocamllabs/ocaml-integers";
    changelog = "https://github.com/ocamllabs/ocaml-integers/raw/${version}/CHANGES.md";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
