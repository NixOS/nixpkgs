{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "sendfile";
  version = "0.7.6";
  sha256 = "0wqbnr07s3g7f6p4x27ips9nzjjz1ii5hw1q54i31g40jzv8rs7z";
  buildDepends = [ network ];
  meta = {
    homepage = "http://patch-tag.com/r/mae/sendfile";
    description = "A portable sendfile library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
