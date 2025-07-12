{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.02.3";

  pname = "ocaml-syntax-shims";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "1j7848khli4p7j8i2kmnvhdnhcwhy3zgdpf5ds5ic30ax69y3cl9";
  };

  useDune2 = true;

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/ocaml-ppx/ocaml-syntax-shims";
    description = "Backport new syntax to older OCaml versions";
    mainProgram = "ocaml-syntax-shims";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
