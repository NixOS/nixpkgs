{cabal, filepath, mtl}:

cabal.mkDerivation (self : {
  pname = "cmdargs";
  version = "0.7";
  sha256 = "0qijfdc66f0r2k272sl41nxfymmsk7naw5is3b4zyxsgm147c0vq";
  propagatedBuildInputs = [filepath mtl];
  meta = {
    description = "Command line argument processing";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

