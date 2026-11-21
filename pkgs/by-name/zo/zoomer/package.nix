{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  wayland,
  wayland-protocols,
  libGL,
  grim,
  nix-update-script,
}:

buildNimPackage (finalAttrs: {
  pname = "zoomer";
  version = "0.0.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cxinu";
    repo = "zoomer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oYDTvqUDw1UwzINQl32xQEUN8anZs3TbJ5qHvgC1k6k=";
  };

  lockFile = ./lock.json;

  nimbleFile = "boomer.nimble";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libGL
  ];

  nimFlags = [ "-d:wayland" ];

  postInstall = ''
    wrapProgram $out/bin/boomer \
      --prefix PATH : ${lib.makeBinPath [ grim ]}
    ln -s boomer $out/bin/zoomer
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Boomer but for Zoomers, zooming application for Linux with Wayland support";
    homepage = "https://github.com/cxinu/zoomer";
    changelog = "https://github.com/cxinu/zoomer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lnk3 ];
    mainProgram = "boomer";
    platforms = lib.platforms.linux;
  };
})
