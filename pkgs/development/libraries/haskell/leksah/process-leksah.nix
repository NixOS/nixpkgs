{cabal}:

cabal.mkDerivation (self : {
  pname = "process-leksah";
  version = "1.0.1.3";
  sha256 = "1pssbpcslrl39z495gf0v2xjgy2i6qpvxbrf4p0hkvrwycr7pnd8";
  meta = {
    description = "This package contains libraries for dealing with system processes";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
