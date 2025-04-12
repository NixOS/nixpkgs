{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "autosubst-ocaml";
  owner = "uds-psl";

  release."1.1+8.19".sha256 = "sha256-AGbhw/6lg4GpDE6hZBhau9DLW7HVXa0UzGvJfSV8oHE=";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = isEq "8.19";
        out = "1.1+8.19";
      }
    ] null;

  buildInputs = with coq.ocamlPackages; [
    angstrom
    ocamlgraph
    ppx_deriving
    ppxlib
  ];
  useDune = true;

  buildPhase = ''
    dune build
  '';

  installPhase = ''
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR
  '';

  meta = with lib; {
    description = "An OCaml reimplementation of the Autosubst 2 code generator";
    homepage = "https://github.com/uds-psl/autosubst-ocaml";
    mainProgram = "autosubst";
    maintainers = with maintainers; [ chen ];
    license = licenses.mit;
  };
}
