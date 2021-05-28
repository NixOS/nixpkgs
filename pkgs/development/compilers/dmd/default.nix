{ callPackage, version }:
if (version == "2.090.1") then callPackage ./bootstrap.nix { }
else if (version == "2.095.1") then callPackage ./sourcebuild.nix {
  inherit version;
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
  dmdSha256 = "sha256:0faca1y42a1h16aml4lb7z118mh9k9fjx3xlw3ki5f1h3ln91xhk";
  druntimeSha256 = "sha256:0ad4pa5llr9m9wqbvfv4yrcra4zz9qxlh5kx43mrv48f9bcxm2ha";
  phobosSha256 = "sha256:04w6jw4izix2vbw62j13wvz6q3pi7vivxnmxqj0g8904j5g0cxjl";
}
else if (version == "2.096.1") then callPackage ./sourcebuild.nix {
  inherit version;
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
  dmdSha256 = "sha256:04s5z2skhvjjxwpgdffgksk6whd2jsyrqb5f57icp1qvm1ywz1vb";
  druntimeSha256 = "sha256:1jzs6qrljs7nvq0dlld9l7f5n2yj306i5czpvxgxymbrcyzzh1q4";
  phobosSha256 = "sha256:0jyxkdy6h35z1cv22pqhx136mcpg8h2hwxr4j4lixpzyr8kw0i4d";
}
else abort "unsupported DMD version ${version}"
