{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, qtest, num }:

let version = "2.8.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-batteries-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml-batteries-team/batteries-included/archive/v${version}.tar.gz";
    sha256 = "1cvgljg8lxvfx0v3367z3p43dysg9m33v8gfy43bhw7fjr1bmyas";
  };

  buildInputs = [ ocaml findlib ocamlbuild qtest ];
  propagatedBuildInputs = [ num ];

  configurePhase = if num != null then ''
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}${num}/lib/ocaml/${ocaml.version}/site-lib/stublibs/"
  '' else "true";      # Skip configure

  doCheck = true;
  checkTarget = "test test";

  createFindlibDestdir = true;

  meta = {
    homepage = http://batteries.forge.ocamlcore.org/;
    description = "OCaml Batteries Included";
    longDescription = ''
      A community-driven effort to standardize on an consistent, documented,
      and comprehensive development platform for the OCaml programming
      language.
    '';
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
