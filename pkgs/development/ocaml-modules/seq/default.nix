{
  stdenv,
  lib,
  ocaml,
}:

stdenv.mkDerivation {
  version = "0.1";
  pname = "ocaml${ocaml.version}-seq";

  meta = {
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/c-cube/seq";
    description = "Dummy backward-compatibility package for iterators";
    inherit (ocaml.meta) platforms;
  };

  src = ./src-base;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/seq
    cp META $out/lib/ocaml/${ocaml.version}/site-lib/seq
  '';

}
