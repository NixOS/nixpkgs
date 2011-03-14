{cabal, mtl, syb}:

cabal.mkDerivation (self : {
  pname = "uniplate";
  version = "1.6";
  sha256 = "13nlyzsnj6hshgl839ww1kp49r87kpdcdyn7hxahg8k2qkj5zzxr";
  propagatedBuildInputs = [mtl syb];
  meta = {
    description = "Uniform type generic traversals";
  };
})  

