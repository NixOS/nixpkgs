{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  astring,
  bos,
  cmdliner,
  rresult,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-webbrowser";
  version = "0.6.1";
  src = fetchurl {
    url = "https://erratique.ch/software/webbrowser/releases/webbrowser-${version}.tbz";
    sha256 = "137a948bx7b71zfv4za3hhznrn5lzbbrgzjy0das83zms508isx3";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [
    astring
    bos
    cmdliner
    rresult
  ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "Open and reload URIs in browsers from OCaml";
    homepage = "https://erratique.ch/software/webbrowser";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "browse";
    inherit (ocaml.meta) platforms;
  };
}
