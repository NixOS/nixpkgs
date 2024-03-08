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
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "HansKristian-Work";
    repo = "vkd3d-proton";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-NhHtuXdoccrvpUSplho1FZd47URTBWhzycXhi7Il0Mc=";
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
    # git describe --always --exclude='*' --abbrev=15 --dirty=0
    # git describe --always --tags --dirty=+
    rev = "105b5b77c9a34fd336b5c604e3c7a6cc48f39c3a";
    shortRev = lib.substring 0 8 rev;
    realVersion = finalAttrs.src.rev;
  in ''
    substituteInPlace meson.build \
      --replace "vkd3d_build = vcs_tag(" \
                "vkd3d_build = vcs_tag( fallback : '${shortRev}'", \
      --replace "vkd3d_version = vcs_tag(" \
                "vkd3d_version = vcs_tag( fallback : '${realVersion}'",
  '';

  meta = {
    homepage = "https://github.com/HansKristian-Work/vkd3d-proton";
    description = "A fork of VKD3D, which aims to implement the full Direct3D 12 API on top of Vulkan";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wine.meta) platforms;
  };
})
