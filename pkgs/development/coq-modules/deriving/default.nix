{ lib, mkCoqDerivation, coq, version ? null
, ssreflect
}:
with lib;

mkCoqDerivation {
  pname = "deriving";
  owner = "arthuraa";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.11" "8.14"; out = "0.1.0"; }
  ] null;

  releaseRev = v: "v${v}";

  release."0.1.0".sha256 = "sha256:11crnjm8hyis1qllkks3d7r07s1rfzwvyvpijya3s6iqfh8c7xwh";

  propagatedBuildInputs = [ ssreflect ];

  mlPlugin = true;

  meta = {
    description = "Generic instances of MathComp classes";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };

}
