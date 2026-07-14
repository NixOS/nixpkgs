{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  stdlib-shims,
}:

buildDunePackage (finalAttrs: {
  pname = "integers";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ocamllabs";
    repo = "ocaml-integers";
    rev = finalAttrs.version;
    sha256 = "sha256-pHbCXVE5J7rNbFIddqlWk7k5gagY87cgD/DQTM9ENw0=";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = {
    description = "Various signed and unsigned integer types for OCaml";
    license = lib.licenses.mit;
    homepage = "https://github.com/ocamllabs/ocaml-integers";
    changelog = "https://github.com/ocamllabs/ocaml-integers/raw/${finalAttrs.version}/CHANGES.md";
    maintainers = [ lib.maintainers.vbgl ];
  };
})
