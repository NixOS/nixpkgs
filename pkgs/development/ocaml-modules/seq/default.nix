{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation ({
  version = "0.1";
  name = "ocaml${ocaml.version}-seq-0.1";

  meta = {
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    homepage = "https://github.com/c-cube/seq";
    inherit (ocaml.meta) platforms;
  };

} // (if stdenv.lib.versionOlder ocaml.version "4.07" then {

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "seq";
    rev = "0.1";
    sha256 = "1cjpsc7q76yfgq9iyvswxgic4kfq2vcqdlmxjdjgd4lx87zvcwrv";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  meta.description = "Compatibility package for OCaml’s standard iterator type starting from 4.07";

} else {

  src = ./src-base;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/seq
    cp META $out/lib/ocaml/${ocaml.version}/site-lib/seq
  '';

  meta.description = "dummy backward-compatibility package for iterators";

}))
