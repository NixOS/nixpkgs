{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  vulkan-headers,
  vulkan-loader,
  libgbm,
  wayland-protocols,
  wayland,
  glm,
  assimp,
  libxcb,
  xcbutilwm,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vkmark";
  version = "2025.01";

  src = fetchFromGitHub {
    owner = "vkmark";
    repo = "vkmark";
    rev = finalAttrs.version;
    sha256 = "sha256-Rjpjqe7htwlhDdwELm74MvSzHzXLhRD/P8IES7nz/VY=";
  };

  postPatch = ''
    substituteInPlace src/meson.build \
      --replace-fail "vulkan_dep.get_pkgconfig_variable('prefix')" "'${vulkan-headers}'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    vulkan-headers
    vulkan-loader
    libgbm
    glm
    assimp
    libxcb
    xcbutilwm
    wayland
    wayland-protocols
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extensible Vulkan benchmarking suite";
    homepage = "https://github.com/vkmark/vkmark";
    license = with lib.licenses; [ lgpl21Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ muscaln ];
    mainProgram = "vkmark";
  };
})
