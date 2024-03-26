{ lib, mkCoqDerivation, coq, version ? null
, ssreflect
}:

mkCoqDerivation {
  pname = "deriving";
  owner = "arthuraa";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [coq.coq-version ssreflect.version] [
    { cases = [(range "8.17" "8.19") (isGe "2.0.0")] ; out = "0.2.0"; }
    { cases = [(range "8.11" "8.19") (isLe "2.0.0")] ; out = "0.1.1"; }
  ] null;

  releaseRev = v: "v${v}";

  release."0.2.0".sha256 = "sha256-xPsuEayHstjF0PGFJZJ+5cm0oMUrpoGLXN23op97vjM=";
  release."0.1.1".sha256 = "sha256-Gu8aInLxTXfAFE0/gWRYI046Dx3Gv1j1+gx92v/UnPI=";
  release."0.1.0".sha256 = "sha256:11crnjm8hyis1qllkks3d7r07s1rfzwvyvpijya3s6iqfh8c7xwh";

  propagatedBuildInputs = [ ssreflect ];

  mlPlugin = true;

  meta = with lib; {
    description = "Generic instances of MathComp classes";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };

}
