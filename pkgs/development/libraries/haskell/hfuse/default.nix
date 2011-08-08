{ cabal, fuse }:

cabal.mkDerivation (self: {
  pname = "HFuse";
  version = "0.2.4";
  sha256 = "1v3kfkm2rz7bvwk0j8p9rhnnsffbnkismnsq0fkgnzi5z0bz5sgv";
  extraBuildInputs = [ fuse ];
  preConfigure = ''
    sed -i -e "s@  Extra-Lib-Dirs:         /usr/local/lib@  Extra-Lib-Dirs:         ${fuse}/lib@" HFuse.cabal
  '';
})
