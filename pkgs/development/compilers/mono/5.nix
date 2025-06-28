{
  callPackage,
  fetchurl,
}:

callPackage ./generic.nix rec {
  version = "5.20.1.34";
  enableParallelBuilding = true;
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration";
  src = fetchurl {
    url = "https://download.mono-project.com/sources/mono/mono-${version}.tar.bz2";
    sha256 = "12vw5dkhmp1vk9l658pil8jiqirkpdsc5z8dm5mpj595yr6d94fd";
  };
}
