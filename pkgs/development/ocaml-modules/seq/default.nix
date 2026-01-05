{
  stdenv,
  lib,
  fetchFromGitHub,
  ocaml,
  findlib,
  ocamlbuild,
}:

stdenv.mkDerivation (
  {
    version = "0.1";
    pname = "ocaml${ocaml.version}-seq";

    meta = {
      license = lib.licenses.lgpl21;
      maintainers = [ lib.maintainers.vbgl ];
      homepage = "https://github.com/c-cube/seq";
      inherit (ocaml.meta) platforms;
    };

  }
  // (
    if lib.versionOlder ocaml.version "4.07" then
      {

        src = fetchFromGitHub {
          owner = "c-cube";
          repo = "seq";
          rev = "0.1";
          sha256 = "1cjpsc7q76yfgq9iyvswxgic4kfq2vcqdlmxjdjgd4lx87zvcwrv";
        };

        nativeBuildInputs = [
          ocaml
          findlib
          ocamlbuild
        ];
        strictDeps = true;

        createFindlibDestdir = true;

        meta.description = "Compatibility package for OCaml’s standard iterator type starting from 4.07";

      }
    else
      {

        src = ./src-base;

        dontBuild = true;

        installPhase = ''
          mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/seq
          cp META $out/lib/ocaml/${ocaml.version}/site-lib/seq
        '';

        meta.description = "Dummy backward-compatibility package for iterators";

      }
  )
)
