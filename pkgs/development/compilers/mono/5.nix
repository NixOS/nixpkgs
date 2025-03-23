{
  callPackage,
  Foundation,
  libobjc,
}:

callPackage ./generic.nix ({
  inherit Foundation libobjc;
  version = "5.20.1.34";
  sha256 = "12vw5dkhmp1vk9l658pil8jiqirkpdsc5z8dm5mpj595yr6d94fd";
  enableParallelBuilding = true;
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration";
})
