{
  stdenv,
  lib,
  fetchurl,
  callPackage,
}:

let
  pname = "upscayl";
  version = "2.15.0";
  srcs = rec {
    x86_64-linux = fetchurl {
      url = "https://github.com/upscayl/upscayl/releases/download/v${version}/upscayl-${version}-linux.AppImage";
      hash = "sha256-ZFlFfliby5nneepELc5gi6zaM5FrcBmohit8YlKqgik=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/upscayl/upscayl/releases/download/v${version}/upscayl-${version}-mac.zip";
      hash = "sha256-gXqeRaNW0g7ZVkCSbxps9SqPMuVSzLTCGL5F3Om/iwo=";
    };
    x86_64-darwin = aarch64-darwin;
  };
  meta = {
    description = "Free and Open Source AI Image Upscaler";
    homepage = "https://upscayl.github.io/";
    maintainers = with lib.maintainers; [
      icy-thought
      matteopacini
    ];
    license = lib.licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    mainProgram = "upscayl";
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      meta
      ;
    src = srcs.${stdenv.hostPlatform.system};
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      meta
      ;
    src = srcs.${stdenv.hostPlatform.system};
  }
