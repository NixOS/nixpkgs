{ lib, fetchFromGitHub, buildDunePackage, ocaml }:

buildDunePackage rec {
  pname = "integers";
  version = "0.5.1";

  useDune2 = lib.versionAtLeast ocaml.version "4.08";

  src = fetchFromGitHub {
    owner = "ocamllabs";
    repo = "ocaml-integers";
    rev = version;
    sha256 = "0by5pc851fk7ccxqy1w2qc5jwn9z8whyqhs5gxlm5986vr9msnyi";
  };

  meta = {
    description = "Various signed and unsigned integer types for OCaml";
    license = lib.licenses.mit;
    homepage = "https://github.com/ocamllabs/ocaml-integers";
    changelog = "https://github.com/ocamllabs/ocaml-integers/raw/${version}/CHANGES.md";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
