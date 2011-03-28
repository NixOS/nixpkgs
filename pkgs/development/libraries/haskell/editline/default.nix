{ cabal, libedit } :

cabal.mkDerivation (self : {
  pname = "editline";
  version = "0.2.1.0";
  sha256 = "83618e5f86074fdc11d7f5033aa2886284462941be38fa02966acc92712c46e1";
  propagatedBuildInputs = [ libedit ];
  meta = {
    description = "Binding to the BSD editline library (libedit)";
  };
})

