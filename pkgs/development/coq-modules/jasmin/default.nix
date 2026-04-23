{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp,
  mathcomp-algebra-tactics,
  mathcomp-word,
  ITree,
  version ? null,
}:

(mkCoqDerivation {
  pname = "jasmin";
  owner = "jasmin-lang";

  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.coq-version [
      (case (range "8.20" "9.1") "2026.03.1")
      (case (isEq "8.19") "2025.02.2")
      (case (isEq "8.18") "2024.07.4")
    ] null;
  releaseRev = v: "v${v}";

  release."2026.03.1".hash = "sha256-CE+WbcG0lgKvaV/OSMlTp3fG+v82X41z/w7ynsM/LLg=";
  release."2026.03.0".hash = "sha256-MzdVbZhXlb9JFLsf+23yJNFiGJDBJZGbX6Ox3/U1EzA=";
  release."2025.06.1".sha256 = "sha256-wEL1tN0HUa1Eb7FiQOBA6sAkuonrAMdkqq8gu9/CED0=";
  release."2025.06.0".sha256 = "sha256-XfTg7ofamzMWqmRIU1/MO+S/ieNjvNEhlgIqFrchdAQ=";
  release."2025.02.2".hash = "sha256-ks0eWqKv7bqgHgMowqTFjKzuT9kMYl2Ozj2s1DaSdEo=";
  release."2025.02.1".sha256 = "sha256-8P2GdplB12Q0e0XdL77w3nQL1/6Xl/gQNhGTB0WX/8I=";
  release."2025.02.0".sha256 = "sha256-Jlf0+VPuYWXdWyKHKHSp7h/HuCCp4VkcrgDAmh7pi5s=";
  release."2024.07.4".hash = "sha256-eA9xX8jhmt8HJAetBj1lrIOYn5edOjO8iHr8uvm9+lE=";
  release."2024.07.3".sha256 = "sha256-n/X8d7ILuZ07l24Ij8TxbQzAG7E8kldWFcUI65W4r+c=";
  release."2024.07.2".sha256 = "sha256-aF8SYY5jRxQ6iEr7t6mRN3BEmIDhJ53PGhuZiJGB+i8=";

  propagatedBuildInputs = [
    mathcomp-algebra-tactics
    mathcomp-word
  ];

  makeFlags = [
    "-C"
    "proofs"
  ];

  meta = {
    description = "Jasmin language & verified compiler";
    homepage = "https://github.com/jasmin-lang/jasmin/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      proux01
      vbgl
    ];
  };
}).overrideAttrs
  (o: {
    propagatedBuildInputs =
      o.propagatedBuildInputs
      ++ lib.optional (o.version == "dev" || lib.versionAtLeast o.version "2025.06") ITree;
  })
