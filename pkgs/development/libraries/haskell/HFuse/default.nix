{ cabal, fuse }:

cabal.mkDerivation (self: {
  pname = "HFuse";
  version = "0.2.4.1";
  sha256 = "12k04dvh92kk2i68bcb70xnk378qxmh46f241k06di5rkcgwyg1k";
  extraLibraries = [ fuse ];
  preConfigure = ''
    sed -i -e "s@  Extra-Lib-Dirs:         /usr/local/lib@  Extra-Lib-Dirs:         ${fuse}/lib@" HFuse.cabal
    sed -i -e "s@  Include-Dirs:           /usr/include, /usr/local/include, .@  Include-Dirs:           ${fuse}/include@" HFuse.cabal
    sed -i -e "s/LANGUAGE FlexibleContexts/LANGUAGE FlexibleContexts, RankNTypes/" System/Fuse.hsc
    sed -i -e "s/E(Exception/E(catch, Exception, IOException/" System/Fuse.hsc
    sed -i -e "s/IO(catch,/IO(/" System/Fuse.hsc
    sed -i -e "s/IO.catch/ E.catch/" System/Fuse.hsc
    sed -i -e "s/const exitFailure/\\\\(_ :: IOException) -> exitFailure/" System/Fuse.hsc
  '';
  meta = {
    homepage = "https://github.com/toothbrush/hfuse";
    description = "HFuse is a binding for the Linux FUSE library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
