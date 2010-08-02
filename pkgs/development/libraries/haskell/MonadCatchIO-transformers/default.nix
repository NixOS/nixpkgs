{cabal, transformers, extensibleExceptions} :

cabal.mkDerivation (self : {
  pname = "MonadCatchIO-transformers";
  version = "0.2.2.0";
  sha256 = "7f3b45ac01ac98476d1305333435005a6876e5c04c562e94ad2426ee7ab6936d";
  propagatedBuildInputs = [transformers extensibleExceptions];
  meta = {
    description = "Monad-transformer compatible version of the Control.Exception module";
  };
})  

