{cabal, benchpress}:

cabal.mkDerivation (self : {
  pname = "maybench";
  version = "0.2.4";
  sha256 = "1g7hby0ffjry60xhs09gf1n848c9n60mjjq7jf94c116x24w1gdd";
  meta = {
    description = "Automated benchmarking tool.";
  };
  propagatedBuildInputs = [benchpress];
})

