{
  lib,
  mkCoqDerivation,
  coq,
  aac-tactics,
  mathcomp-boot,
  version ? null,
}:

mkCoqDerivation {
  pname = "relation-algebra";
  owner = "damien-pous";

  releaseRev = v: if lib.versions.range "1.7.6" "1.7.9" v then "v.${v}" else "v${v}";

  release."1.7.11".sha256 = "sha256-ZOV0lUdduSabW9Qsz70clkO7QK/NK2STaHqBWcXb7nI=";
  release."1.7.10".sha256 = "sha256-h738L+dybhmWZwTSLJrhv+sB+cIbj0+62Zcy9BH5sVo=";
  release."1.7.9".sha256 = "sha256-1WzAZyj6q7s0u/9r7lahzxTl8612EA540l9wpm7TYEg=";
  release."1.7.8".sha256 = "sha256-RITFd3G5TjY+rFzW073Ao1AGU+u6OGQyQeGHVodAXnA=";
  release."1.7.7".sha256 = "sha256:1dff3id6nypl2alhk9rcifj3dab0j78dym05blc525lawsmc26l2";
  release."1.7.6".sha256 = "sha256:02gsj06zcy9zgd0h1ibqspwfiwm36pkkgg9cz37k4bxzcapxcr6w";
  release."1.7.5".sha256 = "sha256-XdO8agoJmNXPv8Ho+KTlLCB4oRlQsb0w06aM9M16ZBU=";
  release."1.7.4".sha256 = "sha256-o+v2CIAa2+9tJ/V8DneDTf4k31KMHycgMBLaQ+A4ufM=";
  release."1.7.3".sha256 = "sha256-4feSNfi7h4Yhwn5L+9KP9K1S7HCPvsvaVWwoQSTFvos=";
  release."1.7.2".sha256 = "sha256-f4oNjXspNMEz3AvhIeYO3avbUa1AThoC9DbcHMb5A2o=";
  release."1.7.1".sha256 = "sha256-WWVMcR6z8rT4wzZPb8SlaVWGe7NC8gScPqawd7bltQA=";

  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.coq-version [
      (case (isEq "8.20") "1.7.11")
      (case (range "8.18" "8.19") "1.7.10")
      (case (isEq "8.17") "1.7.9")
      (case (isEq "8.16") "1.7.8")
      (case (isEq "8.15") "1.7.7")
      (case (isEq "8.14") "1.7.6")
      (case (isEq "8.13") "1.7.5")
      (case (isEq "8.12") "1.7.4")
      (case (isEq "8.11") "1.7.3")
      (case (isEq "8.10") "1.7.2")
      (case (isEq "8.9") "1.7.1")
    ] null;

  mlPlugin = true;

  propagatedBuildInputs = [
    aac-tactics
    mathcomp-boot
  ];

  meta = with lib; {
    description = "Relation algebra library for Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
