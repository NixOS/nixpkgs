{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libGL,
  ffmpeg,
  leptonica,
  libgbm,
  libxkbcommon,
  pipewire,
  tesseract,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wlr-utils";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "sjourdois";
    repo = "wlr-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J2PoWq6FHbiyk9c826V67T7bn5h4dYmN8wQGC/t1GiM=";
  };

  cargoHash = "sha256-LZ5tIZa4EcPqLwXHOmR/iyCVUsnd/u/SDIYIn8CAles=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg
    leptonica
    libgbm
    libxkbcommon
    pipewire
    tesseract
    wayland
  ];

  postFixup = ''
    for program in $out/bin/wlr-*; do
      patchelf --add-needed "${libGL}/lib/libEGL.so.1" $program
    done
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=stable" ];
  };

  __structuredAttrs = true;

  meta = {
    description = "Native Wayland desktop tools for wlroots";
    homepage = "https://github.com/sjourdois/wlr-utils";
    changelog = "https://github.com/sjourdois/wlr-utils/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.linux;
  };
})
