{ lib, mkCoqDerivation, coq, bignums, math-classes, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "corn";
  inherit version;
  defaultVersion = if versions.range "8.6" "8.9" coq.coq-version then "8.8.1" else null;
  release."8.8.1".sha256 = "0gh32j0f18vv5lmf6nb87nr5450w6ai06rhrnvlx2wwi79gv10wp";

  preConfigure = "patchShebangs ./configure.sh";
  configureScript = "./configure.sh";
  dontAddPrefix = true;

  propagatedBuildInputs = [ bignums math-classes ];

  meta = {
    homepage = "http://c-corn.github.io/";
    license = licenses.gpl2;
    description = "A Coq library for constructive analysis";
    maintainers = [ maintainers.vbgl ];
  };
}
