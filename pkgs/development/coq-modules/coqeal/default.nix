{
  coq,
  mkCoqDerivation,
  mathcomp,
  bignums,
  paramcoq,
  multinomials,
  mathcomp-real-closed,
  lib,
  version ? null,
}:

let
  derivation = mkCoqDerivation {

    pname = "CoqEAL";

    inherit version;
    defaultVersion =
      let
        case = coq: mc: out: {
          cases = [
            coq
            mc
          ];
          inherit out;
        };
      in
      with lib.versions;
      lib.switch
        [ coq.coq-version mathcomp.version ]
        [
          (case (range "8.20" "9.1") (isGe "2.3.0") "2.1.1")
          (case (range "8.20" "9.1") (isGe "2.3.0") "2.1.0")
          (case (range "8.16" "8.20") (isGe "2.1.0") "2.0.3")
          (case (range "8.16" "8.20") (isGe "2.0.0") "2.0.1")
          (case (range "8.16" "8.17") (isGe "2.0.0") "2.0.0")
          (case (range "8.15" "8.18") (range "1.15.0" "1.18.0") "1.1.3")
          (case (range "8.13" "8.17") (range "1.13.0" "1.18.0") "1.1.1")
          (case (range "8.10" "8.15") (range "1.12.0" "1.18.0") "1.1.0")
          (case (isGe "8.10") (range "1.11.0" "1.12.0") "1.0.5")
          (case (isGe "8.7") "1.11.0" "1.0.4")
          (case (isGe "8.7") "1.10.0" "1.0.3")
        ]
        null;

    release."2.1.1".sha256 = "sha256-nAQAX35W9br7dgrT9FqGyHYSzwgMiMsuD1d7SztQDwY=";
    release."2.1.0".sha256 = "sha256-UoDxy2BKraDyRsO42GXRo26O74OF51biZQGkIMWLf8Y=";
    release."2.0.3".sha256 = "sha256-5lDq7IWlEW0EkNzYPu+dA6KOvRgy53W/alikpDr/Kd0=";
    release."2.0.1".sha256 = "sha256-d/IQ4IdS2tpyPewcGobj2S6m2HU+iXQmlvR+ITNIcjI=";
    release."2.0.0".sha256 = "sha256-SG/KVnRJz2P+ZxkWVp1dDOnc/JVgigoexKfRUh1Y0GM";
    release."1.1.3".sha256 = "sha256-xhqWpg86xbU1GbDtXXInNCTArjjPnWZctWiiasq1ScU=";
    release."1.1.1".sha256 = "sha256-ExAdC3WuArNxS+Sa1r4x5aT7ylbCvP/BZXfkdQNAvZ8=";
    release."1.1.0".sha256 = "1vyhfna5frkkq2fl1fkg2mwzpg09k3sbzxxpyp14fjay81xajrxr";
    release."1.0.6".sha256 = "0lqkyfj4qbq8wr3yk8qgn7mclw582n3fjl9l19yp8cnchspzywx0";
    release."1.0.5".sha256 = "0cmvky8glb5z2dy3q62aln6qbav4lrf2q1589f6h1gn5bgjrbzkm";
    release."1.0.4".sha256 = "1g5m26lr2lwxh6ld2gykailhay4d0ayql4bfh0aiwqpmmczmxipk";
    release."1.0.3".sha256 = "0hc63ny7phzbihy8l7wxjvn3haxx8jfnhi91iw8hkq8n29i23v24";

    propagatedBuildInputs = [
      mathcomp.algebra
      bignums
      multinomials
    ];

    meta = {
      description = "CoqEAL - The Coq Effective Algebra Library";
      license = lib.licenses.mit;
    };
  };
  patched-derivation1 = derivation.overrideAttrs (o: {
    propagatedBuildInputs =
      o.propagatedBuildInputs
      ++ lib.optional (lib.versions.isGe "1.1" o.version || o.version == "dev") mathcomp-real-closed;
  });
  patched-derivation = patched-derivation1.overrideAttrs (o: {
    propagatedBuildInputs =
      o.propagatedBuildInputs
      ++ lib.optional (lib.versions.isLe "2.0.3" o.version && o.version != "dev") paramcoq;
  });
in
patched-derivation
