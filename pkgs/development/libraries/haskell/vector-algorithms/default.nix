{cabal, primitive, vector}:

cabal.mkDerivation (self : {
  pname = "vector-algorithms";
  version = "0.4";
  sha256 = "04ig2bx3gm42mwhcz5n8kp9sy33d1hrwm940kfxny74fc06422h8";
  propagatedBuildInputs = [primitive vector];
  meta = {
    description = "Efficient algorithms for vector arrays";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

