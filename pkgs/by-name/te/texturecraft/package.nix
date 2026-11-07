{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  craft-fonts,

  nix-update-script,
}:

let
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    wayland
    vulkan-loader
    libxrandr
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "texturecraft";
  version = "0.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "texturecraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9twziHLPD76jxFdv39nMEljtSxJEZVZMePZEhFDb4Gc=";
  };

  cargoHash = "sha256-Pxuzs3Y1Jot2EnSmTFK8UaJqmbfwknVLyt9K3CzTPL0=";

  cargoBuildFlags = [
    "--package=texturecraft"
    "--package=texturecraft-cli"
  ];

  # The `texturecraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=texturecraft-cli"
  ];

  # texturecraft-automation tests talk to loopback TCP control channels.
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
    patchelf
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.texturecraft.desktop \
      $out/share/applications/ai.storyteller.texturecraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.texturecraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.texturecraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/texturecraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source 3D texture painting workflow for PBR materials on meshes";
    homepage = "https://github.com/storytold/texturecraft";
    changelog = "https://github.com/storytold/texturecraft/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
      ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "texturecraft";
    platforms = rustc.meta.platforms;
  };
})
