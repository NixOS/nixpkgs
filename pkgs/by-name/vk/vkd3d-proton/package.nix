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
  version = "2.8-unstable-2023-04-21";

  src = fetchFromGitHub {
    owner = "HansKristian-Work";
    repo = "vkd3d-proton";
    rev = "83308675078e9ea263fa8c37af95afdd15b3ab71";
    fetchSubmodules = true;
    hash = "sha256-iLpVvYmWhqy0rbbyJoT+kxzIqp68Vsb/TkihGtQQucU=";
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
    # these are both embedded in the output files
    # git describe --tags
    shortRev = builtins.substring 0 8 finalAttrs.src.rev;
    realVersion = "v2.8-302-g${shortRev}";
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
    maintainers = with lib.maintainers; [ expipiplus1 ];
    inherit (wine.meta) platforms;
  };
})
