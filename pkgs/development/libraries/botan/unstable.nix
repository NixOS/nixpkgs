{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "12";
  sha256 = "099hbimpqry96xzbv69x1wmqrybcnfn7yw8jj6ljvk6r8wk4qg85";
  openssl = null;
})
