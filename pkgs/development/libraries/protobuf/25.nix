{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "25.2";
  hash = "sha256-Bw7xOgcGLshFppH4qD8E48D8v21ZJRaRkK19LPSATMg=";
} // args)
