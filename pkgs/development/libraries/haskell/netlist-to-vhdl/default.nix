{ cabal, netlist }:

cabal.mkDerivation (self: {
  pname = "netlist-to-vhdl";
  version = "0.3.1";
  sha256 = "15daik7l0pjqilya01l5rl84g2fyjwkap1md0nx82gxcp8m1v76k";
  buildDepends = [ netlist ];
  meta = {
    description = "Convert a Netlist AST to VHDL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
