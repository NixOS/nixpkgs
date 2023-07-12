# Adds support for Serenity
# https://github.com/SerenityOS/serenity/tree/874202045d34d6ab89a2ab06e8643d475b7a56a0/Toolchain/Patches/gcc
{ fetchurl }:
let
  rev = "874202045d34d6ab89a2ab06e8643d475b7a56a0";
  prefix = "https://github.com/SerenityOS/serenity/raw/${rev}/Toolchain/Patches/gcc/";
in
[
  (fetchurl {
    url = "${prefix}/0001-Add-a-gcc-driver-for-SerenityOS.patch";
    sha256 = "0qqzjf3jdx23hql38vpd5d0abpc095mkyxk4syfi1kfzwkl6sv85";
  })
  (fetchurl {
    url = "${prefix}/0002-fixincludes-Skip-for-SerenityOS-targets.patch";
    sha256 = "1vc5fpr1f5xa8691ipcxj70fnxi4r8rf5nps019yr3j97jsjjwi7";
  })
  (fetchurl {
    url = "${prefix}/0003-libgcc-Build-for-SerenityOS.patch";
    sha256 = "0snigbr5vf1dvn4cy7i5yc4swh6fjk4xzzc8gm7k29i7j5ss2h5z";
  })
  (fetchurl {
    url = "${prefix}/0004-libgcc-Do-not-link-libgcc_s-to-LibC.patch";
    sha256 = "1z45ninv3y4bi7qf7686qx9dc96xzd5y264v103c5a6i483gs605";
  })
  (fetchurl {
    url = "${prefix}/0005-i386-Disable-math-errno-for-SerenityOS.patch";
    sha256 = "0rmrgr42axjh9racbsiizdzq9bl47bsykn76pcmxg0rkf8ydkgm3";
  })
  (fetchurl {
    url = "${prefix}/0006-libstdc-Support-SerenityOS.patch";
    sha256 = "0bif1635wrkmjz75yxy8cvvrb5y4mqb6nkn8n57yi4v526plhy5x";
  })
]
