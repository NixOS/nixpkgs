{
  lib,
  callPackage,
  glslang,
  meson,
  ninja,
  stdenv,
  wine,
}:

let
  sources = callPackage ./sources.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  inherit (sources.vkd3d-proton) pname version src;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    glslang
    meson
    ninja
    wine
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vkd3d_build = vcs_tag(" \
                     "vkd3d_build = vcs_tag( fallback : '$(cat .nixpkgs-auxfiles/vkd3d_build)'", \
      --replace-fail "vkd3d_version = vcs_tag(" \
                     "vkd3d_version = vcs_tag( fallback : '$(cat .nixpkgs-auxfiles/vkd3d_version)'",
  '';

  passthru = {
    inherit sources;
  };

  meta = {
    homepage = "https://github.com/HansKristian-Work/vkd3d-proton";
    description = "A fork of VKD3D, which aims to implement the full Direct3D 12 API on top of Vulkan";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ ];
    inherit (wine.meta) platforms;
  };
})
