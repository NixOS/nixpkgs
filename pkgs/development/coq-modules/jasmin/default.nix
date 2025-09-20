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
    with lib.versions;
    lib.switch
      [ coq.version mathcomp.version ]
      [
        {
          cases = [
            (range "8.20" "9.0")
            (range "2.2" "2.4")
          ];
          out = "2025.06.1";
        }
        {
          cases = [
            (range "8.19" "9.0")
            (range "2.2" "2.4")
          ];
          out = "2025.02.1";
        }
        {
          cases = [
            (isEq "8.18")
            (isEq "2.2")
          ];
          out = "2024.07.2";
        }
      ]
      null;
  releaseRev = v: "v${v}";

  release."2025.06.1".sha256 = "sha256-wEL1tN0HUa1Eb7FiQOBA6sAkuonrAMdkqq8gu9/CED0=";
  release."2025.06.0".sha256 = "sha256-XfTg7ofamzMWqmRIU1/MO+S/ieNjvNEhlgIqFrchdAQ=";
  release."2025.02.1".sha256 = "sha256-8P2GdplB12Q0e0XdL77w3nQL1/6Xl/gQNhGTB0WX/8I=";
  release."2025.02.0".sha256 = "sha256-Jlf0+VPuYWXdWyKHKHSp7h/HuCCp4VkcrgDAmh7pi5s=";
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

  meta = with lib; {
    description = "Jasmin language & verified compiler";
    homepage = "https://github.com/jasmin-lang/jasmin/";
    license = licenses.mit;
    maintainers = with maintainers; [
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
