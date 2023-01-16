{ lib, mkCoqDerivation, coq, mathcomp-algebra, mathcomp-finmap
, mathcomp-fingroup, graph-theory, fourcolor
, hierarchy-builder, version ? null }:

with lib;

mkCoqDerivation {
  pname = "graph-theory-planar";

  release."0.9.1".sha256 = "sha256-lRRY+501x+DqNeItBnbwYIqWLDksinWIY4x/iojRNYU=";

  releaseRev = v: "v${v}";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.14" "8.16"; out = "0.9.1"; }
  ] null;

  propagatedBuildInputs = [ mathcomp-algebra mathcomp-finmap mathcomp-fingroup hierarchy-builder
                            graph-theory fourcolor ];

  meta = {
    description = "Graph theory results on planarity in Coq and MathComp";
    longDescription = ''
      Formal definitions and results on graph planarity in Coq using the Mathematical Components
      library, including Wagner's Theorem. Relies on hypermaps and other notions developed
      as part of the Coq proof of the Four-Color Theorem.
    '';
    maintainers = with maintainers; [ cohencyril ];
    license = licenses.cecill-b;
  };
}
