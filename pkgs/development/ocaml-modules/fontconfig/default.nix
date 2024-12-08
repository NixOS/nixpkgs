{ stdenv, lib, fetchFromGitHub, pkg-config, fontconfig, ocaml }:

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-fontconfig";
  version = "unstable-2013-11-03";

  src = fetchFromGitHub {
    owner = "flh";
    repo = "ocaml-fontconfig";
    rev = "42daf1697ffcee9c89ee4be3103b6427f7a7b7e5";
    sha256 = "1fw6bzydmnyh2g4x35mcbg0hypnxqhynivk4nakcsx7prr8zr3yh";
  };

  postPatch = lib.optionalString (lib.versionAtLeast ocaml.version "4.03") ''
    substituteInPlace extract_consts.ml \
      --replace String.lowercase String.lowercase_ascii \
      --replace String.capitalize String.capitalize_ascii
  '';

  nativeBuildInputs = [ pkg-config ocaml ];
  buildInputs = [ fontconfig ];

  strictDeps = true;

  makeFlags = [
    "OCAML_STDLIB_DIR=$(out)/lib/ocaml/${lib.getVersion ocaml}/site-lib/"
    "OCAML_HAVE_OCAMLOPT=yes"
  ];

  meta = {
    description = "Fontconfig bindings for OCaml";
    license = lib.licenses.gpl2Plus;
    platforms = ocaml.meta.platforms;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
