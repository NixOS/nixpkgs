{ stdenv, ghdl-llvm, ghdl-mcode, backend }:

let
  ghdl = if backend == "llvm" then ghdl-llvm else ghdl-mcode;
in
stdenv.mkDerivation {
  name = "ghdl-test-simple";
  meta.timeout = 300;
  nativeBuildInputs = [ ghdl ];
  buildCommand = ''
    cp ${./simple.vhd} simple.vhd
    cp ${./simple-tb.vhd} simple-tb.vhd
    mkdir -p ghdlwork
    ghdl -a --workdir=ghdlwork --ieee=synopsys simple.vhd simple-tb.vhd
    ghdl -e --workdir=ghdlwork --ieee=synopsys -o sim-simple tb
  '' + (if backend == "llvm" then ''
    ./sim-simple --assert-level=warning > output.txt
  '' else ''
    ghdl -r --workdir=ghdlwork --ieee=synopsys tb > output.txt
  '') + ''
    diff output.txt ${./expected-output.txt} && touch $out
  '';
}
