/* Topkg is a packager for distributing OCaml software. This derivation
provides facilities to describe derivations for OCaml libraries
using topkg.
The `buildPhase` and `installPhase` attributes can be reused directly
in many cases. When more fine-grained control on how to run the “topkg”
build system is required, the attribute `run` can be used.
*/
{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, result, opaline }:

if !stdenv.lib.versionAtLeast ocaml.version "4.01"
then throw "topkg is not available for OCaml ${ocaml.version}"
else

let
/* This command allows to run the “topkg” build system.
 * It is usually called with `build` or `test` as argument.
 * Packages that use `topkg` may call this command as part of
 *  their `buildPhase` or `checkPhase`.
*/
  run = "ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ pkg/pkg.ml";
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-topkg-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "http://erratique.ch/software/topkg/releases/topkg-${version}.tbz";
    sha256 = "1df61vw6v5bg2mys045682ggv058yqkqb67w7r2gz85crs04d5fw";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ result ];

  buildPhase = "${run} build";
  createFindlibDestdir = true;
  installPhase = "${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  passthru = { inherit run; };

  meta = {
    homepage = https://erratique.ch/software/topkg;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    description = "A packager for distributing OCaml software";
    inherit (ocaml.meta) platforms;
  };
}
