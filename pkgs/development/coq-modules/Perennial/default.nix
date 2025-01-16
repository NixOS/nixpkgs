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
        out = "2024-12-16";
      }
    ] null;

  release."2024-12-16" = {
    rev = "e28f1b537cd138210190d3ec5c384acb5d67db78";
    sha256 = "sha256-fQul9Do/iOK+tBCtb4umcwbC2AxteAGbwDzhXsXoSMQ=";
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

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}
    mkdir -p $COQLIB/user-contrib/Perennial
    cp -pR src/* $COQLIB/user-contrib/Perennial
  '';

  meta = {
    description = "Verifying concurrent crash-safe systems";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}
