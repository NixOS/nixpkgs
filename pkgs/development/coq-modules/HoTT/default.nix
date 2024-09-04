{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "HoTT";
  repo = "Coq-HoTT";
  owner = "HoTT";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.14" "8.19"; out = coq.coq-version; }
  ] null;
  releaseRev = v: "V${v}";
  release."8.14".sha256 = "sha256-7kXk2pmYsTNodHA+Qts3BoMsewvzmCbYvxw9Sgwyvq0=";
  release."8.15".sha256 = "sha256-JfeiRZVnrjn3SQ87y6dj9DWNwCzrkK3HBogeZARUn9g=";
  release."8.16".sha256 = "sha256-xcEbz4ZQ+U7mb0SEJopaczfoRc2GSgF2BGzUSWI0/HY=";
  release."8.17".sha256 = "sha256-GjTUpzL9UzJm4C2ilCaYEufLG3hcj7rJPc5Op+OMal8=";
  release."8.18".sha256 = "sha256-URoUoQOsG0432wg9i6pTRomWQZ+ewutq2+V29TBrVzc=";
  release."8.19".sha256 = "sha256-igG3mhR6uPXV+SCtPH9PBw/eAtTFFry6HPT5ypWj3tQ=";

  # versions of HoTT for Coq 8.17 and onwards will use dune
  # opam-name = if lib.versions.isLe "8.17" coq.coq-version then "coq-hott" else null;
  opam-name = "coq-hott";
  useDune = lib.versions.isGe "8.17" coq.coq-version;

  patchPhase = ''
    patchShebangs etc
  '';

  meta = {
    homepage = "https://homotopytypetheory.org/";
    description = "Homotopy Type Theory library";
    longDescription = ''
      Homotopy Type Theory is an interpretation of Martin-Löf’s intensional
      type theory into abstract homotopy theory. Propositional equality is
      interpreted as homotopy and type isomorphism as homotopy equivalence.
      Logical constructions in type theory then correspond to
      homotopy-invariant constructions on spaces, while theorems and even
      proofs in the logical system inherit a homotopical meaning. As the
      natural logic of homotopy, type theory is also related to higher
      category theory as it is used e.g. in the notion of a higher topos.

      The HoTT library is a development of homotopy-theoretic ideas in the Coq
      proof assistant. It draws many ideas from Vladimir Voevodsky's
      Foundations library (which has since been incorporated into the Unimath
      library) and also cross-pollinates with the HoTT-Agda library.
    '';
    maintainers = with lib.maintainers; [ alizter siddharthist ];
  };
}
