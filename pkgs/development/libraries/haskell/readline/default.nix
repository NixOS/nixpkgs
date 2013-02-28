{ cabal, readline, ncurses }:

cabal.mkDerivation (self: {
  pname = "readline";
  version = "1.0.3.0";
  sha256 = "1sszlx34qa88fad3wlhd4rkb1my1nrpzvyd8vq7dn806j5sf3ff0";
  propagatedBuildInputs = [ readline ncurses ];
  # experimentally link with ncursesw because ghci can't interpret ld scripts,
  # and ncurses sometimes seems to be a script pointing to ncursesw
  postConfigure = ''
    sed -i -e "/^extra-libraries/ s/ncurses/ncursesw/" readline.buildinfo
  '';
  meta = {
    description = "An interface to the GNU readline library";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
