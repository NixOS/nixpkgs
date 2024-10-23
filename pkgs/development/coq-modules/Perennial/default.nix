{
  coq,
  coq-record-update,
  coq-tactical,
  coqutil,
  iris,
  iris-named-props,
  lib,
  mkCoqDerivation,
  stdpp,
  version ? null,
}:

mkCoqDerivation {
  pname = "Perennial";
  owner = "mit-pdos";

  inherit version;
  displayVersion.Perennial = v: "unstable-${v}";
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.16" "8.20";
        out = "2024-10-17";
      }
    ] null;

  release."2024-10-17" = {
    rev = "e06197fd52cf9cf2565dd961c1b75ff21a7644de";
    sha256 = "sha256-DSg/T8s+Jzuooe/cCJl6QAFFJmAw31T9kja3MjAljV0=";
  };

  preConfigure =
    let
      mkCoqLibReplaceStr = drv: name: "-Q ${drv}/lib/coq/${coq.coq-version}/user-contrib/${name} ";
    in
    ''
      substituteInPlace _CoqProject \
        --replace-fail '-Q external/stdpp/stdpp ' "${mkCoqLibReplaceStr stdpp stdpp.pname}" \
        --replace-fail '-Q external/stdpp/stdpp_unstable ' "${mkCoqLibReplaceStr stdpp stdpp.pname}" \
        --replace-fail '-Q external/stdpp/stdpp_bitvector ' "${mkCoqLibReplaceStr stdpp stdpp.pname}" \
        --replace-fail '-Q external/iris/iris ' "${mkCoqLibReplaceStr iris iris.pname}" \
        --replace-fail '-Q external/iris/iris_deprecated ' "${mkCoqLibReplaceStr iris iris.pname}" \
        --replace-fail '-Q external/iris/iris_unstable ' "${mkCoqLibReplaceStr iris iris.pname}" \
        --replace-fail '-Q external/iris/iris_heap_lang ' "${mkCoqLibReplaceStr iris iris.pname}" \
        --replace-fail '-Q external/coqutil/src/coqutil ' "${mkCoqLibReplaceStr coqutil coqutil.pname}" \
        --replace-fail '-Q external/record-update/src ' "${mkCoqLibReplaceStr coq-record-update "RecordUpdate"}" \
        --replace-fail '-Q external/coq-tactical/src ' "${mkCoqLibReplaceStr coq-tactical "Tactical"}" \
        --replace-fail '-Q external/iris-named-props/src ' "${mkCoqLibReplaceStr iris-named-props "iris_named_props"}"
    '';

  makeFlags = [ "TIMED=false" ];

  propagatedBuildInputs = [
    coq-record-update
    coq-tactical
    coqutil
    iris
    iris-named-props
    stdpp
  ];

  meta = {
    description = "Verifying concurrent crash-safe systems";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}
