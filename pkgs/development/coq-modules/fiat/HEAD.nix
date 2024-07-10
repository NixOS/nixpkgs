{lib, mkCoqDerivation, coq, python27, version ? null }:

mkCoqDerivation rec {
  pname = "fiat";
  owner = "mit-plv";
  repo = "fiat";
  displayVersion = { fiat = v: "unstable-${v}"; };
  inherit version;
  defaultVersion = if coq.coq-version == "8.5" then "2016-10-24" else null;
  release."2016-10-24".rev    = "7feb6c64be9ebcc05924ec58fe1463e73ec8206a";
  release."2016-10-24".sha256 = "16y57vibq3f5i5avgj80f4i3aw46wdwzx36k5d3pf3qk17qrlrdi";

  mlPlugin = true;
  buildInputs = [ python27 ];

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
    description = "Library for the Coq proof assistant for synthesizing efficient correct-by-construction programs from declarative specifications";
    maintainers = with lib.maintainers; [ jwiegley ];
  };
}
