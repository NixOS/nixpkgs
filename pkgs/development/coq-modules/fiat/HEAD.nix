{lib, mkCoqDerivation, coq, python27, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "fiat";
  owner = "mit-plv";
  repo = "fiat";
  displayVersion = { fiat = v: "unstable-${v}"; };
  inherit version;
  defaultVersion = if coq.coq-version == "8.5" then "2016-10-24" else null;
  release."2016-10-24".rev    = "7feb6c64be9ebcc05924ec58fe1463e73ec8206a";
  release."2016-10-24".sha256 = "0griqc675yylf9rvadlfsabz41qy5f5idya30p5rv6ysiakxya64";

  mlPlugin = true;
  extraBuildInputs = [ python27 ];

  prePatch = "patchShebangs etc/coq-scripts";

  doCheck = false;

  enableParallelBuilding = false;
  buildPhase = "make -j$NIX_BUILD_CORES";

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Fiat
    cp -pR src/* $COQLIB/user-contrib/Fiat
  '';

  meta = {
    homepage = "http://plv.csail.mit.edu/fiat/";
    description = "A library for the Coq proof assistant for synthesizing efficient correct-by-construction programs from declarative specifications";
    maintainers = with maintainers; [ jwiegley ];
  };
}
