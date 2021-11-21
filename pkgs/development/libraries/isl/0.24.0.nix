import ./generic.nix rec {
  version = "0.24";
  urls = [
    "mirror://sourceforge/libisl/isl-${version}.tar.xz"
    "https://libisl.sourceforge.io/isl-${version}.tar.xz"
  ];
  sha256 = "1ak1gq0rbqbah5517blg2zlnfvjxfcl9cjrfc75nbcx5p2gnlnd5";
  configureFlags = [
    "--with-gcc-arch=generic" # don't guess -march=/mtune=
  ];
}
