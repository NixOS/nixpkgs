{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.10";
  revision = "13";
  sha256 = "144vl65z7bys43sxgb09mbisyf2nmh49wh0d957y0ksa9cyrgv13";
  extraConfigureFlags = "--with-gnump";
})
