{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.1.1";
  branch = "2.1";
  revision = "v2.1.1";
  sha256 = "1hrn10byrlw7hb7hwv2zvff89rxy3bsbn0im5ki4kdk63jw5p601";
})
