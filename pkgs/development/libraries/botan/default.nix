{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.10";
  revision = "12";
  sha256 = "09xcbrs48c9sgy6cj37qbc69gi6wlkjd6r3fi4zr8xwmj5wkmz5g";
  extraConfigureFlags = "--with-gnump";
})
