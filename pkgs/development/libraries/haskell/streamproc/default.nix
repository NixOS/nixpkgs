{cabal}:

cabal.mkDerivation (self : {
  pname = "streamproc";
  version = "1.4";
  sha256 = "fbff569d7b294850998e9a6b6a14bf81484b1adb312801ea15d1d890faff12cf";
  propagatedBuildInputs = [];
  meta = {
    homepage = "http://gitorious.org/streamproc";
    description = "Stream Processer Arrow";
    license = self.stdenv.lib.licenses.bsd3;
  };
})
