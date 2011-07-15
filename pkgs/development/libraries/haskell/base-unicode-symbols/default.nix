{cabal}:

cabal.mkDerivation (self : {
  pname = "base-unicode-symbols";
  version = "0.2.1.5";
  sha256 = "1ir1dckrpax4xlrfp7jdsjn7s403a8n8mcmv3wdnpzkg1klfahyq";
  meta = {
    description = "Unicode alternatives for common functions and operators";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

