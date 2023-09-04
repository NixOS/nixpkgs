{ coq, mkCoqDerivation, mathcomp, bignums, paramcoq, multinomials,
  mathcomp-real-closed,
  lib, version ? null }:

(mkCoqDerivation {

  pname = "CoqEAL";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version mathcomp.version ]  [
      { cases = [ (range "8.15" "8.18") (isGe "1.15.0") ]; out = "1.1.3"; }
      { cases = [ (range "8.13" "8.17") (isGe "1.13.0") ]; out = "1.1.1"; }
      { cases = [ (range "8.10" "8.15") (isGe "1.12.0") ]; out = "1.1.0"; }
      { cases = [ (isGe "8.10") (range "1.11.0" "1.12.0") ]; out = "1.0.5"; }
      { cases = [ (isGe "8.7") "1.11.0" ]; out = "1.0.4"; }
      { cases = [ (isGe "8.7") "1.10.0" ]; out = "1.0.3"; }
    ] null;

  release."1.1.3".sha256 = "sha256-xhqWpg86xbU1GbDtXXInNCTArjjPnWZctWiiasq1ScU=";
  release."1.1.1".sha256 = "sha256-ExAdC3WuArNxS+Sa1r4x5aT7ylbCvP/BZXfkdQNAvZ8=";
  release."1.1.0".sha256 = "1vyhfna5frkkq2fl1fkg2mwzpg09k3sbzxxpyp14fjay81xajrxr";
  release."1.0.6".sha256 = "0lqkyfj4qbq8wr3yk8qgn7mclw582n3fjl9l19yp8cnchspzywx0";
  release."1.0.5".sha256 = "0cmvky8glb5z2dy3q62aln6qbav4lrf2q1589f6h1gn5bgjrbzkm";
  release."1.0.4".sha256 = "1g5m26lr2lwxh6ld2gykailhay4d0ayql4bfh0aiwqpmmczmxipk";
  release."1.0.3".sha256 = "0hc63ny7phzbihy8l7wxjvn3haxx8jfnhi91iw8hkq8n29i23v24";

  propagatedBuildInputs = [ mathcomp.algebra bignums paramcoq multinomials ];

  meta = {
    description = "CoqEAL - The Coq Effective Algebra Library";
    license = lib.licenses.mit;
  };
}).overrideAttrs (o: {
  propagatedBuildInputs = o.propagatedBuildInputs
  ++ lib.optional (lib.versions.isGe "1.1" o.version || o.version == "dev") mathcomp-real-closed;
})
