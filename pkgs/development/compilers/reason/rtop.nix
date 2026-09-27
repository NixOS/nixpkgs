{
  buildDunePackage,
  reason,
  cppo,
  utop,
  makeWrapper,
}:

buildDunePackage {
  pname = "rtop";

  # The toplevel loads the rtop library at runtime,
  # so the library can't be split into a separate "dev" output.
  outputs = [ "out" ];

  inherit (reason) version src;

  nativeBuildInputs = [
    makeWrapper
    cppo
  ];

  propagatedBuildInputs = [
    reason
    utop
  ];

  postInstall = ''
    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --prefix CAML_LD_LIBRARY_PATH : "$CAML_LD_LIBRARY_PATH" \
      --prefix OCAMLPATH : "$OCAMLPATH:$OCAMLFIND_DESTDIR"
  '';

  meta = reason.meta // {
    description = "Toplevel (or REPL) for Reason, based on utop";
    mainProgram = "rtop";
  };
}
