{cabal}:

cabal.mkDerivation (self : {
  pname = "tagsoup";
  version = "0.12";
  sha256 = "0jaqr6q8asn7gd336xsblcc55lzm8glzlhvs61mhzjvk4hg9pmg7";
  meta = {
    description = "Parsing and extracting information from (possibly malformed) HTML/XML documents";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

