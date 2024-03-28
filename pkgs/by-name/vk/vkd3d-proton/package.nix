{ lib
, fetchFromGitHub
, glslang
, meson
, ninja
, stdenv
, wine
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vkd3d-proton";
  version = "2.11.1-unstable-2024-03-07";

  src = fetchFromGitHub {
    owner = "HansKristian-Work";
    repo = "vkd3d-proton";
    rev = "ffb04fb7091f932ca95da236d63ab9a4064d6443";
    fetchSubmodules = true;
    hash = "sha256-xkDWquEbsJD6b8vvZsMHiqN0IgyyNY0G36ol8Sq041U=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    glslang
    meson
    ninja
    wine
  ];

  strictDeps = true;

  prePatch = let
    # these are both embedded in the output files; they are obtained via
    # vkd3dBuild = $(git describe --always --exclude='*' --abbrev=15 --dirty=0)
    # vkd3dVersion = $(git describe --always --tags --dirty=+)
    inherit (finalAttrs.src) rev; # Change this to raw rev when needed
    vkd3dBuild = lib.substring 0 15 rev;
    vkd3dVersion = "v2.11.1-135-g${lib.substring 0 8 rev}";
  in ''
    substituteInPlace meson.build \
      --replace "vkd3d_build = vcs_tag(" \
                "vkd3d_build = vcs_tag( fallback : '${vkd3dBuild}'", \
      --replace "vkd3d_version = vcs_tag(" \
                "vkd3d_version = vcs_tag( fallback : '${vkd3dVersion}'",
  '';

  meta = {
    homepage = "https://github.com/HansKristian-Work/vkd3d-proton";
    description = "A fork of VKD3D, which aims to implement the full Direct3D 12 API on top of Vulkan";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wine.meta) platforms;
  };
})
