args @ { version, callPackage, ...}:
if (version == "2.095.1") then callPackage ./sourcebuild.nix ({
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
  dmdSha256 = "0faca1y42a1h16aml4lb7z118mh9k9fjx3xlw3ki5f1h3ln91xhk";
  druntimeSha256 = "0ad4pa5llr9m9wqbvfv4yrcra4zz9qxlh5kx43mrv48f9bcxm2ha";
  phobosSha256 = "04w6jw4izix2vbw62j13wvz6q3pi7vivxnmxqj0g8904j5g0cxjl";
} // args)
else if (version == "2.096.1") then callPackage ./sourcebuild.nix ({
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
  dmdSha256 = "04s5z2skhvjjxwpgdffgksk6whd2jsyrqb5f57icp1qvm1ywz1vb";
  druntimeSha256 = "1jzs6qrljs7nvq0dlld9l7f5n2yj306i5czpvxgxymbrcyzzh1q4";
  phobosSha256 = "0jyxkdy6h35z1cv22pqhx136mcpg8h2hwxr4j4lixpzyr8kw0i4d";
} // args)
else if (version == "2.097.0") then callPackage ./sourcebuild.nix ({
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
  dmdSha256 = "0rbbsxz91sp9kmn8qjkqjbx5p49l4xldjf55bay22nc6v6k5p3mk";
  druntimeSha256 = "18jwqvls0dwjxr1zf76igybrr5kq0p1raskm26hrih9jh47vlpdx";
  phobosSha256 = "1ipa3804zqnvywqw0g7rcy3vvd16sik2gvhjg1r8klnqviizvhgh";
} // args)

else callPackage ./sourcebuild.nix ({
  HOST_DMD = "${callPackage ./bootstrap.nix { }}/bin/dmd";
} // args) # caller needs to provide the hashes
