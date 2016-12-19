{ stdenv, fetchFromGitHub, pkgconfig, fontconfig, ocaml }:

stdenv.mkDerivation {
  name = "ocaml-fontconfig-20131103";
  src = fetchFromGitHub {
    owner = "flh";
    repo = "ocaml-fontconfig";
    rev = "42daf1697ffcee9c89ee4be3103b6427f7a7b7e5";
    sha256 = "1fw6bzydmnyh2g4x35mcbg0hypnxqhynivk4nakcsx7prr8zr3yh";
  };

  buildInputs = [ ocaml pkgconfig fontconfig ];
  makeFlags = "OCAML_STDLIB_DIR=$(out)/lib/ocaml/${stdenv.lib.getVersion ocaml}/site-lib/ OCAML_HAVE_OCAMLOPT=yes";

  meta = {
    description = "Fontconfig bindings for OCaml";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
