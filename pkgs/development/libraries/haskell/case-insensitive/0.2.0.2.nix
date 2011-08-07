{cabal, text}:

cabal.mkDerivation (self : {
  pname = "case-insensitive";
  version = "0.2.0.2";
  sha256 = "0qn2scaxxbqi4770nwvcmb1ldj0ipa2ljxcavcn0kv48xzs519l7";
  propagatedBuildInputs = [text];
  meta = {
    description = "Case insensitive string comparison";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

