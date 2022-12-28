/* Topkg is a packager for distributing OCaml software. This derivation
provides facilities to describe derivations for OCaml libraries
using topkg.
The `buildPhase` and `installPhase` attributes can be reused directly
in many cases. When more fine-grained control on how to run the “topkg”
build system is required, the attribute `run` can be used.
*/
{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, result, opaline }:

let
  param =
  if lib.versionAtLeast ocaml.version "4.03" then {
    version = "1.0.3";
    sha256 = "0b77gsz9bqby8v77kfi4lans47x9p2lmzanzwins5r29maphb8y6";
  } else {
    version = "1.0.0";
    sha256 = "1df61vw6v5bg2mys045682ggv058yqkqb67w7r2gz85crs04d5fw";
    propagatedBuildInputs = [ result ];
  };

/* This command allows to run the “topkg” build system.
 * It is usually called with `build` or `test` as argument.
 * Packages that use `topkg` may call this command as part of
 *  their `buildPhase` or `checkPhase`.
*/
  run = "ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ pkg/pkg.ml";
in

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-topkg";
  inherit (param) version;

  src = fetchurl {
    url = "https://erratique.ch/software/topkg/releases/topkg-${version}.tbz";
    inherit (param) sha256;
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = param.propagatedBuildInputs or [];

  strictDeps = true;

  buildPhase = "${run} build";
  createFindlibDestdir = true;
  installPhase = "${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  passthru = { inherit run; };

  meta = {
    homepage = "https://erratique.ch/software/topkg";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    description = "A packager for distributing OCaml software";
    inherit (ocaml.meta) platforms;
  };
}
