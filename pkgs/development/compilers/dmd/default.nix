# This file should support dmd versions 2.minor.patch in the long term where minor
# is divisable by 4 and patch is the last available. Plus the latest stable
# release.

# Other versions might work by specifying the hashes and HOST_DMD in callPackage
# parameters in the client side but they have not been tested

args @ { version, callPackage, ...}:
if (version == "2.092.1") then callPackage ./sourcebuild.nix ({
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
  dmdSha256 = "1x4fspsk91cdf3pc3sfhhk47511acdbwd458wai2sirkqsdypmnm";
  druntimeSha256 = "0rmqlnw1jlgsh6jjvw6bbmyn26v0xnygqdny699y93g0jldasas4";
  phobosSha256 = "0mw4bad9af7z54dc2rs1aa9h63p3z6bf0fq14v2iyyq4y08ikxzc";
} // args)
else if (version == "2.096.1") then callPackage ./sourcebuild.nix ({
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
  dmdSha256 = "04s5z2skhvjjxwpgdffgksk6whd2jsyrqb5f57icp1qvm1ywz1vb";
  druntimeSha256 = "1jzs6qrljs7nvq0dlld9l7f5n2yj306i5czpvxgxymbrcyzzh1q4";
  phobosSha256 = "0jyxkdy6h35z1cv22pqhx136mcpg8h2hwxr4j4lixpzyr8kw0i4d";
} // args)
else if (version == "2.097.2") then callPackage ./sourcebuild.nix ({
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
  dmdSha256 = "16ldkk32y7ln82n7g2ym5d1xf3vly3i31hf8600cpvimf6yhr6kb";
  druntimeSha256 = "1sayg6ia85jln8g28vb4m124c27lgbkd6xzg9gblss8ardb8dsp1";
  phobosSha256 = "0czg13h65b6qwhk9ibya21z3iv3fpk3rsjr3zbcrpc2spqjknfw5";
} // args)
else callPackage ./sourcebuild.nix ({
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
} // args) # caller needs to provide the hashes
